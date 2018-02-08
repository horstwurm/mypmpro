class IotsController < ApplicationController
  before_action :set_iot, only: [:show, :edit, :update, :destroy]

  # GET /iots
  # GET /iots.json
  def index
    if params[:scope]
      @scope = params[:scope]
      if params[:del]
        Iot.where('frame=?',@scope).destroy_all
        @del = nil
      end
      @iots = Iot.where('frame=?',params[:scope]).order(:frame, :name)
    else
      @iots = Iot.last(100)
    end
  end

  # GET /iots/1
  # GET /iots/1.json
  def show
  end

  # GET /iots/new
  def new
    @iot = Iot.new
  end

  # GET /iots/1/edit
  def edit
  end

  # POST /iots
  # POST /iots.json
  def create
    @iot = Iot.new(iot_params)

    respond_to do |format|
      if @iot.save
        format.html { redirect_to @iot, notice: 'Iot was successfully created.' }
        format.json { render :show, status: :created, location: @iot }
      else
        format.html { render :new }
        format.json { render json: @iot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /iots/1
  # PATCH/PUT /iots/1.json
  def update
    respond_to do |format|
      if @iot.update(iot_params)
        format.html { redirect_to @iot, notice: 'Iot was successfully updated.' }
        format.json { render :show, status: :ok, location: @iot }
      else
        format.html { render :edit }
        format.json { render json: @iot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /iots/1
  # DELETE /iots/1.json
  def destroy
    @iot.destroy
    respond_to do |format|
      format.html { redirect_to iots_url, notice: 'Iot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iot
      @iot = Iot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def iot_params
      params.require(:iot).permit(:owner_id, :owner_type, :frame, :name, :value)
    end
end
