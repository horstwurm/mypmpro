class DeputiesController < ApplicationController
  before_action :set_deputy, only: [:show, :edit, :update, :destroy]

  # GET /deputies
  # GET /deputies.json
  def index
    if params[:search]
      session[:search] = params[:search]
    end
    if params[:user_id]
      @owner = User.find(params[:user_id])
      @owner_type = "User"
    end
    if params[:company_id]
      @owner = Company.find(params[:company_id])
      @owner_type = "Company"
    end
    if params[:page]
      session[:page] = params[:page]
    end
    
    if params[:deputy_id]
      @deputy = Deputy.where('owner_type=? and owner_id=? and userid=?', @owner_type, @owner.id, params[:deputy_id]).first
      if !@deputy
        @deputy = Deputy.new
        @deputy.userid = params[:deputy_id]
        @deputy.owner_type = @owner_type
        @deputy.owner_id = @owner.id
      end
      @deputy.save
    end
    if params[:nodeputy_id]
      @deputy = Deputy.where('owner_type=? and owner_id=? and userid=?', @owner_type, @owner.id, params[:nodeputy_id]).first
      if @deputy
        @deputy.destroy
      end
    end

    @users = User.search(false, session[:search]).page(params[:page]).per_page(10)
    @deputies = @owner.deputies
    @array=[]
    @deputies.each do |d|
      hash = Hash.new
      hash = {"key" => d.userid}
      @array << hash
    end

  end

  # GET /deputies/1
  # GET /deputies/1.json
  def show
  end

  # GET /deputies/new
  def new
    @deputy = Deputy.new
    @deputy.userid = params[:user_id]
    @deputy.owner_id = params[:owner_id]
    @deputy.owner_type = params[:owner_type]
    respond_to do |format|
      if @deputy.save
        if @deputy.owner_type == "User"
          format.html { redirect_to user_path(:id => @deputy.owner_id, :topic => "personen_stellvertretungen"), notice: (I18n.t :act_create) }
        end
        if @deputy.owner_type == "Company"
          format.html { redirect_to company_path(:id => @deputy.owner_id, :topic => "institutionen_stellvertretungen"), notice: (I18n.t :act_create) }
        end
        format.json { render :show, status: :created, location: @deputy }
      else
        format.html { render :new }
        format.json { render json: @deputy.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /deputies/1/edit
  def edit
  end

  # POST /deputies
  # POST /deputies.json
  def create
    @deputy = Deputy.new(deputy_params)

    respond_to do |format|
      if @deputy.save
        if @deputy.owner_type == "User"
          format.html { redirect_to user_path(:id => @deputy.owner_id, :topic => "personen_stellvertretungen"), notice: (I18n.t :act_create) }
        end
        if @deputy.owner_type == "Company"
          format.html { redirect_to company_path(:id => @deputy.owner_id, :topic => "institutionen_stellvertretungen"), notice: (I18n.t :act_create) }
        end
        format.json { render :show, status: :created, location: @deputy }
      else
        format.html { render :new }
        format.json { render json: @deputy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deputies/1
  # PATCH/PUT /deputies/1.json
  def update
    respond_to do |format|
      if @deputy.update(deputy_params)
        if @deputy.owner_type == "User"
          format.html { redirect_to user_path(:id => @deputy.owner_id, :topic => "personen_stellvertretungen"), notice: (I18n.t :act_update)}
        end
        if @deputy.owner_type == "Company"
          format.html { redirect_to company_path(:id => @deputy.owner_id, :topic => "institutionen_stellvertretungen"), (I18n.t :act_update) }
        end
        format.json { render :show, status: :created, location: @deputy }
        format.json { render :show, status: :ok, location: @deputy }
      else
        format.html { render :edit }
        format.json { render json: @deputy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deputies/1
  # DELETE /deputies/1.json
  def destroy
    @deputy_owner_type = @deputy.owner_type
    @deputy_owner_id = @deputy.owner_id
    @deputy.destroy
    respond_to do |format|
        if @deputy_owner_type == "User"
          format.html { redirect_to user_path(:id => @deputy_owner_id, :topic => "personen_stellvertretungen"), notice: (I18n.t :act_delete) }
        end
        if @deputy_owner_type == "Company"
          format.html { redirect_to company_path(:id => @deputy_owner_id, :topic => "institutionen_stellvertretungen"), notice: (I18n.t :act_delete) }
        end
        format.json { render :show, status: :created, location: @deputy }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deputy
      @deputy = Deputy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deputy_params
      params.require(:deputy).permit(:owner_id, :owner_type, :user_id, :date_from, :date_to)
    end
end
