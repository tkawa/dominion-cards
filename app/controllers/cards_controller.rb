class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.order(:id)

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @cards }
    end
  end

  def show
    if params[:id].match(/\w+,\w+/)
      # GET /cards/1,2,3,4,5,6,7,8,9,10
      # GET /cards/1,2,3,4,5,6,7,8,9,10.json
      @cards = Card.where(:id => params[:id].split(',')).order(:cost, :potion)

      respond_to do |format|
        format.html { render :pick } # pick.html.haml
        format.json { render json: @cards }
      end
    else
      # GET /cards/1
      # GET /cards/1.json
      @card = Card.find(params[:id])

      respond_to do |format|
        format.html # show.html.haml
        format.json { render json: @card }
      end
    end
  end

  # POST /cards
  # POST /cards.json
  def create
    sets = params[:sets].select{|k,v| v.to_i == 1 }.keys
    cards = Card.kingdom.where(:set => sets)
    pick_ids = []
    if params[:costs] == 'each_plus6'
      (2..5).each do |cost|
        pick = cards.find_all {|card| card.cost == cost }.sample
        pick_ids << pick.id if pick
      end
      cards.delete_if {|card| pick_ids.include?(card.id) }
      pick_ids.concat(cards.sample(10 - pick_ids.size).map(&:id))
    else # random
      pick_ids = cards.pluck(:id).sample(10)
    end
    redirect_to card_url(id: pick_ids.sort.join(',')), status: :see_other # 303
  end
end
