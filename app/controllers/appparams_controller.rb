class AppparamsController < ApplicationController
  before_action :set_appparam, only: [:show, :edit, :update, :destroy]

  # GET /appparams
  def index
    if params[:id]
      @c = Appparam.find(params[:id])
      if @c
        if @c.access
          @c.access=false
        else
          @c.access=true
        end
        @c.save
      end
    end

    @appparams = Appparam.all

  end

  # GET /appparams/1
  def show
  end

  # GET /appparams/new
  def new
    @appparam = Appparam.new
  end

  # GET /appparams/1/edit
  def edit
  end

  # POST /appparams
  def create
    @appparam = Appparam.new(appparam_params)

    if @appparam.save
      redirect_to appparams_path :page => session[:page], notice: 'Appparam was successfully created.'
    else
      render :new
    end
  end

  # PUT /appparams/1
  def update
    if @appparam.update(appparam_params)
      redirect_to appparams_path :page => session[:page], notice: 'Appparam was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /appparams/1
  def destroy
    @appparam.destroy
    redirect_to appparams_path :page => session[:page], notice: 'Appparam was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appparam
      @appparam = Appparam.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def appparam_params
      params.require(:appparam).permit(:domain, :parent_domain, :icon, :right, :access)
    end
    
    
end
