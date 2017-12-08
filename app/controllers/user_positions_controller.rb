class UserPositionsController < ApplicationController
  before_action :set_user_position, only: [:show, :edit, :update, :destroy]

  # GET /user_positions
  def index
    @user_positions = UserPosition.all
  end

  # GET /user_positions/1
  def show
  end

  # GET /user_positions/new
  def new
    @user_position = UserPosition.new
    @user_position.user_id = current_user.id
  end

  # GET /user_positions/1/edit
  def edit
  end

  # POST /user_positions
  def create
    @user_position = UserPosition.new(user_position_params)
    if @user_position.save
      redirect_to user_path(:id => @user_position.user_id, :topic => "personen_transaktionen"), notice: (I18n.t :act_create)
    else
      render :new
    end
  end

  # PUT /user_positions/1
  def update
    if @user_position.update(user_position_params)
      redirect_to user_path(:id => @user_position.user_id, :topic => "personen_transaktionen"), notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /user_positions/1
  def destroy
    @id = @user_position.user.id
    @user_position.destroy
    redirect_to user_path(:id => @id, :topic => "personen_mappositionen"), notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_position
      @user_position = UserPosition.find(params[:id])
    end
    def user_position_params
      params.require(:user_position).permit(:user_id, :latitude, :longitude, :geo_address)
    end

end
