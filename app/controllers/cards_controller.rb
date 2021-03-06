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
    case params[:id]
    when /\w+,\w+/
      # GET /cards/1,2,3,4,5,6,7,8,9,10
      # GET /cards/1,2,3,4,5,6,7,8,9,10.json
      @pick = Pick.new do |p|
        p.card_ids = params[:id].split(',')
      end
      if @pick.do_pick_by_card_ids
        redirect_to pick_url(@pick), status: :moved_permanently # 301
      else
        respond_to do |format|
          format.html { render 'picks/show' }
          format.json { render json: @pick }
        end
      end
    when /\A\d+\Z/
      # GET /cards/1
      # GET /cards/1.json
      @card = Card.find(params[:id])
      redirect_to @card, status: :moved_permanently # 301
    else
      # GET /cards/name
      # GET /cards/name.json
      @card = Card.find_by_canonical_name!(params[:id])
      respond_to do |format|
        format.html # show.html.haml
        format.json { render json: @card }
      end
    end
  end
end
