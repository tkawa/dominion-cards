class HomeController < ApplicationController
  def index
    @pick = Pick.new(sets: ['base'], promos: Card.promo_canonical_names, cost_condition: :each_plus6)
    @pick.assign_attributes(session[:preceding]) if session[:preceding]
  end
end
