class HomeController < ApplicationController
  def index
    @pick = Pick.new(cost_condition: :each_plus6)
  end
end
