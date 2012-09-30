# -*- encoding: utf-8 -*-
class Card < ActiveRecord::Base
  include Enumerize
  enumerize :set, :in => [:base, :intrigue, :seaside, :alchemy, :prosperity, :cornucopia, :hinterlands, :dark_ages, :promo]

  scope :kingdom, -> { where(:division => '王国') }

  def canonical_name
    name.tr("'", "").parameterize.underscore
  end
  def cost_p
    "#{cost}#{'p' * potion.to_i}"
  end
  def image_url(size = 'small-ja')
    "http://dominion-cards.s3-ap-northeast-1.amazonaws.com/#{size}/#{canonical_name.camelize.gsub(/\s/, '')}.png"
  end
end
