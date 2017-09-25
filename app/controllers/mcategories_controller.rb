class McategoriesController < ApplicationController
  before_action :set_mcategory, only: [:show, :edit, :update, :destroy]

  # GET /mcategories
  def index
    @mcategories = Mcategory.where("ctype=?",params[:ctype])
    @canz = @mcategories.count
    @cat = params[:ctype]
  end

  # GET /mcategories/1
  def show
  end

  # GET /mcategories/new
  def new
    @mcategory = Mcategory.new
    if params[:ctype]
      @mcategory.ctype = params[:ctype]
    end
  end

  # GET /mcategories/1/edit
  def edit
  end

  # POST /mcategories
  def create
    @mcategory = Mcategory.new(mcategory_params)

    if @mcategory.save
      redirect_to mcategories_path(:ctype => @mcategory.ctype), notice: (I18n.t :act_create)
    else
      render :new
    end
  end

  # PUT /mcategories/1
  def update
    if @mcategory.update(mcategory_params)
      redirect_to mcategories_path(:ctype => @mcategory.ctype), notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /mcategories/1
  def destroy
    @ctype = @mcategory.ctype
    @mcategory.destroy

    redirect_to mcategories_path(:ctype => @ctype), notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mcategory
      @mcategory = Mcategory.find(params[:id])
    end
    def mcategory_params
      params.require(:mcategory).permit(:name, :ctype)
    end

end
