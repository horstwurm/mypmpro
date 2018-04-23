class CompanyParamsController < ApplicationController
  before_action :set_company_param, only: [:show, :edit, :update, :destroy]

  # GET /company_params
  # GET /company_params.json
  def index
    @company_params = CompanyParam.all
  end

  # GET /company_params/1
  # GET /company_params/1.json
  def show
  end

  # GET /company_params/new
  def new
    @company_param = CompanyParam.new
  end

  # GET /company_params/1/edit
  def edit
  end

  # POST /company_params
  # POST /company_params.json
  def create
    @company_param = CompanyParam.new(company_param_params)

    respond_to do |format|
      if @company_param.save
        format.html { redirect_to @company_param, notice: 'Company param was successfully created.' }
        format.json { render :show, status: :created, location: @company_param }
      else
        format.html { render :new }
        format.json { render json: @company_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_params/1
  # PATCH/PUT /company_params/1.json
  def update
    respond_to do |format|
      if @company_param.update(company_param_params)
        format.html { redirect_to company_path(:id => @company_param.company_id), notice: 'Company param was successfully updated.' }
        format.json { render :show, status: :ok, location: @company_param }
      else
        format.html { render :edit }
        format.json { render json: @company_param.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_params/1
  # DELETE /company_params/1.json
  def destroy
    @company_param.destroy
    respond_to do |format|
      format.html { redirect_to company_params_url, notice: 'Company param was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_param
      @company_param = CompanyParam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_param_params
      params.require(:company_param).permit(:company_id, :sponsoring_wert1, :sponsoring_wert2, :sponsoring_wert3, :sponsoring_wert4, :sponsoring_wert5, :sponsoring_init, :sponsoring_ok, :sponsoring_ok_change, :sponsoring_nok, :role_company, :role_sponsoring, :color1, :color2)
    end
end


