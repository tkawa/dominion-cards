# -*- encoding: utf-8 -*-
class Card < ActiveRecord::Base
  include Enumerize
  enumerize :set, in: [:base, :intrigue, :seaside, :alchemy, :prosperity, :cornucopia, :hinterlands, :dark_ages, :promo]

  scope :kingdom, -> { where(division: '王国') }
  scope :prize, -> { where(division: '褒賞') }
  scope :promos, -> { where(set: 'promo') }

  def self.promo_canonical_names
    promos.pluck(:canonical_name)
  end
  def to_param
    canonical_name
  end
  def cost_p
    "#{cost}#{'p' * potion.to_i}"
  end
  def image_url(size = 'small-ja')
    "http://dominion-cards.s3-ap-northeast-1.amazonaws.com/#{size}/#{canonical_name.underscore.camelize.gsub(/\s/, '')}.png"
  end
  def kingdom?
    division == '王国'
  end
end
