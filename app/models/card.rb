class Card < ActiveRecord::Base
  attr_accessible :actions, :buys, :cards, :coins, :cost, :description, :division, :kana, :kind, :name, :name_j, :potion, :set, :treasure, :victory, :vp_tokens
end
