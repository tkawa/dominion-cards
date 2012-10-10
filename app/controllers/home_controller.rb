class HomeController < ApplicationController
  def index
    @pick = Pick.new(sets: ['base'], promos: Card.promo_canonical_names, cost_condition: :each_plus6)
  end
end
