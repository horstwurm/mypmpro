class MvdetailsController < ApplicationController
  before_action :set_mvdetail, only: [:show, :edit, :update, :destroy]

  # GET /mvdetails
  # GET /mvdetails.json
  def index
    @mvdetails = Mvdetail.all
  end

  # GET /mvdetails/1
  # GET /mvdetails/1.json
  def show
  end

  # GET /mvdetails/new
  def new
    @mvdetail = Mvdetail.new
    @mvdetail.mobject_id = 1
    @mvdetail.name = "hallo"
    @mvdetail.description = "hi"
    @mvdetail.sequence=1
  end

  # GET /mvdetails/1/edit
  def edit
  end

  # POST /mvdetails
  # POST /mvdetails.json
  def create
    @mvdetail = Mvdetail.new(mvdetail_params)

    respond_to do |format|
      if @mvdetail.save
        format.html { redirect_to @mvdetail, notice: 'Mvdetail was successfully created.' }
        format.json { render :show, status: :created, location: @mvdetail }
      else
        format.html { render :new }
        format.json { render json: @mvdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mvdetails/1
  # PATCH/PUT /mvdetails/1.json
  def update
    respond_to do |format|
      if @mvdetail.update(mvdetail_params)
        format.html { redirect_to @mvdetail, notice: 'Mvdetail was successfully updated.' }
        format.json { render :show, status: :ok, location: @mvdetail }
      else
        format.html { render :edit }
        format.json { render json: @mvdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mvdetails/1
  # DELETE /mvdetails/1.json
  def destroy
    @mvdetail.destroy
    respond_to do |format|
      format.html { redirect_to mvdetails_url, notice: 'Mvdetail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mvdetail
      @mvdetail = Mvdetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mvdetail_params
      params.require(:mvdetail).permit(:mobject_id, :name, :description, :sequence, :video)
    end
end
