class PicksController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid
  rescue_from ConditionInvalid, with: :see_cards

  def index
  end

  # GET /picks/1
  # GET /picks/1.json
  def show
    @pick = Pick.find(params[:id])
    @pick.write_conditions(flash[:preceding]) if flash[:preceding]

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @pick }
    end
  end

  # POST /picks
  # POST /picks.json
  def create
    @pick = Pick.new(params[:pick])

    @pick.do_pick!
    redirect_to pick_url(@pick), flash: {preceding: params[:pick]}, status: :see_other # 303
  end

  private
  def render_invalid
    flash[:alert] = @pick.errors.full_messages.join("\n")
    respond_to do |format|
      format.html { render 'home/index', status: :unprocessable_entity }
      format.json { render json: @pick.errors, status: :unprocessable_entity }
    end
  end

  def see_cards
    redirect_to card_url(id: @pick.card_ids.join(',')), alert: @pick.errors.full_messages.join("\n"), status: :see_other # 303
  end
end
