class PicksController < ApplicationController
  def index
  end

  # GET /picks/1
  # GET /picks/1.json
  def show
    card_ids = Pick.pick_id_to_card_ids(params[:id].to_i)
    @cards = Card.where(:id => card_ids).order('COALESCE(cost, 0), COALESCE(potion, 0)')

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @cards }
    end
  end

  # POST /picks
  # POST /picks.json
  def create
    sets = params[:sets].select{|k,v| v.to_i == 1 }.keys
    cards = Card.kingdom.where(:set => sets).select([:id, :cost])
    card_ids = []
    if params[:costs] == 'each_plus6'
      (2..5).each do |cost|
        card = cards.find_all {|c| c.cost == cost }.sample
        card_ids << card.id if card
      end
      cards.delete_if {|card| card_ids.include?(card.id) }
      card_ids.concat(cards.sample(10 - card_ids.size).map(&:id))
    else # random
      card_ids = cards.pluck(:id).sample(10)
    end
    redirect_to pick_url(id: Pick.card_ids_to_pick_id(card_ids.sort)), status: :see_other # 303
  end
end
