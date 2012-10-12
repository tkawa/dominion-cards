# -*- encoding: utf-8 -*-
class Pick
  include ActiveAttr::Model
  include Enumerize

  attribute :id
  attribute :cards
  attribute :appended_cards, default: []
  attribute :pick_name
  attribute :card_ids, default: []
  attribute :sets, default: []
  attribute :promos, default: []
  attribute :options, default: []
  OPTIONS = [:no_potion, :no_prize, :more_attack, :more_reaction]
  attribute :cost_condition
  enumerize :cost_condition, in: [:each_plus6, :random, :manual], default: :each_plus6
  attribute :counts, default: {}
  COUNTS = [:auto, 0, 1, 2, 3, 4, 5, 6]
  COUNTS_FOR_SELECT = COUNTS.map{|n| n.is_a?(Integer) ? [I18n.t('enumerize.pick.details.number', count: n), n]
                                                      : [I18n.t(n, scope: 'enumerize.pick.details'), n] }
  attr_accessible :sets, :promos, :options, :cost_condition, :counts

  def self.for_select(options, scope)
    options.map{|o| [I18n.t(o, scope: ['enumerize.pick', scope], default: o.to_s.underscore.humanize), o] }
  end

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
    raise ArgumentError.new('number is too large') if pick_id >= combination(180, 10)
    card_ids = []
    10.downto(1) do |r|
      n = r-1
      n += 1 until combination(n, r) > pick_id
      card_ids << n-1
      pick_id -= combination(n-1, r)
    end
    card_ids.sort
  end

  def self.find(id)
    self.new do |p|
      p.id = id
      p.cards = find_cards!(id)
      p.appended_cards = Card.prize.order('COALESCE(cost, 0), COALESCE(potion, 0)') if p.cards.any? {|c| c.canonical_name == 'tournament' }
      p.pick_name = PickName.find_by_pick_id(id)
    end
  end

  def self.find_cards!(id)
    card_ids = pick_id_to_card_ids(id.to_i)
    cards = Card.where(id: card_ids).order('COALESCE(cost, 0), COALESCE(potion, 0)')
    raise ::ActiveRecord::RecordNotFound, "Couldn't find Pick with ID=#{id}" if cards.any? {|c| !c.kingdom? }
    cards
  end

  def do_pick_by_card_ids
    do_pick_by_card_ids! rescue nil
    consistent?
  end

  def do_pick_by_card_ids!
    self.cards = Card.where(id: card_ids).all
    if self.cards.size == 10 && self.cards.all?(&:kingdom?)
      card_ids.sort!
      self.id = Pick.card_ids_to_pick_id(card_ids)
    else
      orders = Hash[*(card_ids.each_with_index.map{|id, i| [id.to_i, i]}.flatten)]
      self.cards.sort_by! {|card| orders[card.id] }
    end
  end

  def do_pick!
    raise ::ActiveRecord::RecordInvalid.new(self) unless valid?
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

  def consistent?
    id.present?
  end

  private
  def randomize
    self.sets.delete('')
    candidates = Card.kingdom.where(set: self.sets).select([:id, :cost, :kind])

    exclude_promos = Card.promo_canonical_names - self.promos
    if self.sets.include?('promo') && exclude_promos.present?
      candidates = candidates.where('canonical_name NOT IN (?)', exclude_promos)
    end
    if self.options.include?('no_potion')
      candidates = candidates.where(potion: nil)
    end
    if self.options.include?('no_prize')
      candidates = candidates.where('canonical_name <> ?', 'tournament')
    end

    candidates = candidates.all
    if self.cost_condition == 'each_plus6'
      (2..5).each do |cost|
        subdivision = candidates.find_all {|c| c.cost == cost }
        self.card_ids.concat(sample_card_ids(subdivision, 1)) unless subdivision.empty?
      end
      candidates.delete_if {|c| self.card_ids.include?(c.id) }
      self.card_ids.concat(sample_card_ids(candidates, 10 - self.card_ids.size))
    elsif self.cost_condition == 'manual'
      self.counts.each do |cost, count|
        next if count == 'auto'
        subdivision = candidates.find_all {|c| c.cost == cost.to_i }
        self.card_ids.concat(sample_card_ids(subdivision, count.to_i))
        candidates.delete_if {|c| c.cost == cost.to_i }
      end
      self.card_ids.concat(sample_card_ids(candidates, 10 - self.card_ids.size))
    else # cost_condition == 'random'
      self.card_ids = sample_card_ids(candidates, 10)
    end
    self.card_ids.sort!
  end

  def sample_card_ids(candidates, count)
    candidates = candidates.dup
    if candidates.size <= count
      candidates
    else
      # add 2x weight
      if self.options.include?('more_attack')
        candidates.concat(candidates.find_all {|c| c.kind.match('アタック') })
      end
      if self.options.include?('more_reaction')
        candidates.concat(candidates.find_all {|c| c.kind.match('リアクション') })
      end
      begin
        samples = candidates.sample(count)
      end while samples.uniq!(&:id)
      samples
    end.map(&:id)
  end
end

class ConditionInvalid < ActiveRecord::RecordInvalid
end
