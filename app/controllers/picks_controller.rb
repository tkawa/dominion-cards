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
    @pick = Pick.new(params[:pick])

    if @pick.do_pick
      redirect_to pick_url(@pick), notice: 'Pick was successfully created.', status: :see_other # 303
    else
      respond_to do |format|
        format.html { redirect_to root_url, alert: 'error' }
        format.json { render json: @pick.errors, status: :unprocessable_entity }
      end
    end
  end
end
