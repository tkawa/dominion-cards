# -*- encoding: utf-8 -*-
class Pick
  include ActiveAttr::Model
  include Enumerize

  attribute :id
  attribute :card_ids, default: []
  attribute :sets, default: ['base']
  attribute :options, default: []
  OPTIONS = [:no_potion, :no_prize, :more_attack, :more_reaction]
  OPTIONS_FOR_SELECT = OPTIONS.map{|o| [I18n.t(o, scope: 'enumerize.pick.options', default: o.to_s.humanize), o] }
  attribute :cost_condition
  enumerize :cost_condition, :in => [:each_plus6, :random, :manual], default: :each_plus6
  attribute :kind_condition
  enumerize :kind_condition, :in => [:random, :manual], default: :random
  attribute :counts
  COUNTS = [:auto, 0, 1, 2, 3, 4, 5, 6]
  COUNTS_FOR_SELECT = COUNTS.map{|n| n.is_a?(Integer) ? [I18n.t('enumerize.pick.details.number', count: n), n]
                                                      : [I18n.t(n, scope: 'enumerize.pick.details'), n] }

  # ready for Pascal's triangle table
  @@pascals = [[1]]
  1.upto(180) do |i|
    @@pascals << 1.upto(i-1).map {|j| @@pascals[i-1][j-1] + @@pascals[i-1][j] }.unshift(1).push(1)
  end
  def self.combination(n, r)
    (n < r) ? 0 : @@pascals[n][r]
  end

  def self.card_ids_to_pick_id(card_ids)
    raise ArgumentError.new('array size is not 10') unless card_ids.size == 10
    pick_id = 0
    card_ids.map(&:to_i).sort.each_with_index {|id, index| pick_id += combination(id, index + 1) }
    pick_id
  end
  def self.pick_id_to_card_ids(pick_id)
    raise ArgumentError.new('number is too large') if pick_id >= self.combination(180, 10)
    card_ids = []
    10.downto(1) do |r|
      n = r-1
      n += 1 until combination(n, r) > pick_id
      card_ids << n-1
      pick_id -= combination(n-1, r)
    end
    card_ids.sort
  end

  def do_pick!
    raise ActiveRecord::RecordInvalid.new(self) unless valid?
    randomize
    self.id = Pick.card_ids_to_pick_id(card_ids)
  rescue ArgumentError
    e = 'picked_cards_are_too_few'
    errors.add :base, I18n.t(e, scope: 'errors.messages', default: e.humanize)
    raise ConditionInvalid.new(self)
  end

  def do_pick
    do_pick! rescue false
  end

  def to_param
    id
  end

  private
  def randomize
    self.sets.delete('')
    cards = Card.kingdom.where(:set => self.sets).select([:id, :cost, :kind])

    if self.options.include?('no_potion')
      cards = cards.where(:potion => nil)
    end
    if self.options.include?('no_prize')
      cards = cards.where("name <> 'Tournament'")
    end

    cards = cards.all
    if self.cost_condition == 'each_plus6'
      (2..5).each do |cost|
        pots = cards.find_all {|c| c.cost == cost }
        self.card_ids.concat(sample_card_ids(pots, 1)) unless pots.empty?
      end
      cards.delete_if {|c| self.card_ids.include?(c.id) }
      self.card_ids.concat(sample_card_ids(cards, 10 - self.card_ids.size))
    elsif self.cost_condition == 'manual'
      self.counts.each do |cost, count|
        next if count == 'auto'
        pots = cards.find_all {|c| c.cost == cost.to_i }
        self.card_ids.concat(sample_card_ids(pots, count.to_i))
        cards.delete_if {|c| c.cost == cost.to_i }
      end
      self.card_ids.concat(sample_card_ids(cards, 10 - self.card_ids.size))
    else # cost_condition == 'random'
      self.card_ids = sample_card_ids(cards, 10)
    end
    self.card_ids.sort!
  end

  def sample_card_ids(cards, count)
    cards = cards.dup
    if cards.size <= count
      cards
    else
      # add 2x weight
      if self.options.include?('more_attack')
        cards.concat(cards.find_all {|c| c.kind.match('アタック') })
      end
      if self.options.include?('more_reaction')
        cards.concat(cards.find_all {|c| c.kind.match('リアクション') })
      end
      begin
        samples = cards.sample(count)
      end while samples.uniq!(&:id)
      samples
    end.map(&:id)
  end
end

class ConditionInvalid < ActiveRecord::RecordInvalid
end
