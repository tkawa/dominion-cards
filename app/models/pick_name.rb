class PickName < ActiveRecord::Base
  #belongs_to :pick
  #attr_accessible :description, :name, :name_j

  def self.build_from_names(card_names_str, name)
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
end
