class Card < ActiveRecord::Base
  include Enumerize
  enumerize :set, :in => [:base, :intrigue, :seaside, :alchemy, :prosperity, :cornucopia, :hinterlands, :dark_ages, :promo]

  def cost_p
    "#{cost}#{'p' * potion.to_i}"
  end
end
