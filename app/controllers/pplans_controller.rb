class PplansController < ApplicationController
  before_action :set_pplan, only: [:show, :edit, :update, :destroy]

  # GET /pplans
  # GET /pplans.json
  def index
    @pplans = Pplan.all
  end

  # GET /pplans/1
  # GET /pplans/1.json
  def show
  end

  # GET /pplans/new
  def new
    @pplan = Pplan.new
    @pplan.mobject_id = params[:mobject_id]
    @pplan.date_from = Date.today
    @pplan.date_to = Date.today
    @pplan.poc = 0
    @pplan.task=""
    @pplan.tasktype = "Aktivität"
  end

  # GET /pplans/1/edit
  def edit
  end

  # POST /pplans
  # POST /pplans.json
  def create
    @pplan = Pplan.new(pplan_params)
    if @pplan.tasktype == "Meilenstein"
      @pplan.date_to = @pplan.date_from
    end

    respond_to do |format|
      if @pplan.save
        format.html { redirect_to mobject_path(:id => @pplan.mobject_id, :topic => "objekte_projektplan"), notice: 'Pplan was successfully created.' }
        format.json { render :show, status: :created, location: @pplan }
      else
        format.html { render :new }
        format.json { render json: @pplan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pplans/1
  # PATCH/PUT /pplans/1.json
  def update
    respond_to do |format|
      if @pplan.update(pplan_params)
        format.html { redirect_to mobject_path(:id => @pplan.mobject_id, :topic => "objekte_projektplan"),  notice: 'Pplan was successfully updated.' }
        format.json { render :show, status: :ok, location: @pplan }
      else
        format.html { render :edit }
        format.json { render json: @pplan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pplans/1
  # DELETE /pplans/1.json
  def destroy
    @pplan_mobject_id = @pplan.mobject_id
    @pplan.destroy
    respond_to do |format|
      format.html { redirect_to mobject_path(:id => @pplan_mobject_id, :topic => "objekte_projektplan"), notice: 'Pplan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pplan
      @pplan = Pplan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pplan_params
      params.require(:pplan).permit(:mobject_id, :task, :version, :version_name, :date_from, :date_to, :tasktype, :position, :poc)
    end
end
