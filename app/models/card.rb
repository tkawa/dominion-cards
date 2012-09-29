class Card < ActiveRecord::Base
  include Enumerize
  enumerize :set, :in => [:base, :intrigue, :seaside, :alchemy, :prosperity, :cornucopia, :hinterlands, :promo]
end
