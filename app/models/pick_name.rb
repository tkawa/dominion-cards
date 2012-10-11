class PickName < ActiveRecord::Base
  delegate :cards, :appended_cards, to: :pick

  def self.build_from_names(card_names_str)
    name, card_names_str = card_names_str.split(/\s*:\s*/, 2)
    card_names = card_names_str.split(/\s*,\s*/)
    pick = Pick.new do |p|
      p.card_ids = Card.where(name: card_names).pluck(:id)
    end
    pick.do_pick_by_card_ids!
    self.new do |p|
      p.pick_id = pick.id
      p.name = name
      p.canonical_name = name.tr("'", "").parameterize
    end
  end

  def pick
    @pick ||= Pick.find(pick_id)
  end
end
