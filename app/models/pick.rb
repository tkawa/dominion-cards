class Pick
  include ActiveAttr::Model
  include Enumerize

  attribute :id
  attribute :card_ids, default: []
  attribute :sets, default: ['base']
  attribute :options, default: []
  OPTIONS = [:no_potion, :no_prize]
  OPTIONS_FOR_SELECT = OPTIONS.map{|o| [I18n.t(o, scope: 'enumerize.pick.options'), o] }
  attribute :cost_condition
  enumerize :cost_condition, :in => [:each_plus6, :random], default: :each_plus6

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

  def do_pick
    return false unless valid?
    randomize
    self.id = Pick.card_ids_to_pick_id(card_ids)
  end

  def to_param
    id
  end

  private
  def randomize
    self.sets.delete('')
    cards = Card.kingdom.where(:set => self.sets).select([:id, :cost])

    if self.options.include?('no_potion')
      cards = cards.where(:potion => nil)
    end
    if self.options.include?('no_prize')
      cards = cards.where('name != "Tournament"')
    end

    if self.cost_condition == 'each_plus6'
      (2..5).each do |cost|
        card = cards.find_all {|c| c.cost == cost }.sample
        self.card_ids << card.id if card
      end
      cards.delete_if {|card| self.card_ids.include?(card.id) }
      self.card_ids.concat(cards.sample(10 - self.card_ids.size).map(&:id))
    else # cost_condition == 'random'
      self.card_ids = cards.pluck(:id).sample(10)
    end
    self.card_ids.sort!
  end
end