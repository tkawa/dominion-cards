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
      card_ids = params[:id].split(',')
      @cards = Card.where(:id => card_ids)
      if card_ids.size == 10 && @cards.all?(&:kingdom?)
        redirect_to pick_url(id: Pick.card_ids_to_pick_id(card_ids)), status: :moved_permanently # 301
      else
        orders = Hash[*(card_ids.each_with_index.map{|id, i| [id.to_i, i]}.flatten)]
        @cards.sort_by! {|card| orders[card.id] }
        respond_to do |format|
          format.html { render 'picks/show' }
          format.json { render json: @cards }
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
