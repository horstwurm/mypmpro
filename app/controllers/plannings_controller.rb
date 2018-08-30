class PlanningsController < ApplicationController
  before_action :set_planning, only: [:show, :edit, :update, :destroy]

  # GET /plannings
  # GET /plannings.json
  def index
    @plannings = Planning.all
  end

  # GET /plannings/1
  # GET /plannings/1.json
  def show
  end

  # GET /plannings/new
  def new
    @planning = Planning.new
    @planning.amount = 50
    @planning.mobject_id = params[:mobject_id]
    @planning.user_id = params[:user_id]
    @planning.jahr = params[:year].to_s
    @planning.monat = params[:month].to_s
    @planning.description = ""
    if params[:scope]
      @planning.costortime = params[:scope]
    else
      @planning.costortime = "aufwand"
    end
  end

  # GET /plannings/1/edit
  def edit
  end

  # POST /plannings
  # POST /plannings.json
  def create
    @planning = Planning.new(planning_params)

    respond_to do |format|
      if @planning.save
        format.html { redirect_to user_path(:id => @planning.user_id, :topic => "personen_ressourcenplanung", :scope => @planning.costortime, :year => @planning.jahr, :month => @planning.monat), notice: (I18n.t :act_create)}
        format.json { render :show, status: :created, location: @planning }
      else
        format.html { render :new }
        format.json { render json: @planning.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plannings/1
  # PATCH/PUT /plannings/1.json
  def update
    respond_to do |format|
      if @planning.update(planning_params)
        format.html { redirect_to user_path(:id => @planning.user_id, :topic => "personen_ressourcenplanung", :scope => @planning.costortime, :year => @planning.jahr, :month => @planning.monat), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @planning }
      else
        format.html { render :edit }
        format.json { render json: @planning.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plannings/1
  # DELETE /plannings/1.json
  def destroy
    @planning_user_id = @planning.user_id
    @planning_costortime = @planning.costortime
    @planning.destroy
    respond_to do |format|
      format.html { redirect_to user_path(:id => @planning_user_id, :topic => "personen_ressourcenplanung", :scope => @planning_costortime), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_planning
      @planning = Planning.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def planning_params
      params.require(:planning).permit(:user_id, :costortime, :mobject_id, :jahr, :monat, :amount, :description)
    end
end
