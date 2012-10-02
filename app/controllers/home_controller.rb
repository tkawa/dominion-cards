class HomeController < ApplicationController
  def index
    @pick = Pick.new(cost_option: :each_plus6)
  end
end
