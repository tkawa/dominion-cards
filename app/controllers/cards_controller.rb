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
      @cards = Card.find(params[:id].split(','))

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
    ids = Card.where(:set => sets).pluck(:id).sample(10).sort
    redirect_to card_url(id: ids.join(',')), status: :see_other # 303
  end
end
