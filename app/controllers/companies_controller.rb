class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  $branchen_codes = []

  # GET /companies
  def index

    @controller_name = controller_name
    
    if params[:page]
      session[:page] = params[:page]
    end
    if params[:filter_id]
      @filter_id = params[:filter_id]
    end
    
    @companies = Company.search(params[:filter_id], params[:search]).order(created_at: :desc).page(params[:page]).per_page(50)
    @companz = @companies.count

  end

  # GET /companies/1
  def show

     if params[:topic]
       @topic = params[:topic]
     else 
       @topic = "institutionen_info"
     end 
    
    @mtypes = Mobject.select("mtype").distinct
    @stats = [["Aktivtäten","Anzahl"]]
    @stats << ["Partnerlinks", @company.partner_links.count ]
    @stats << ["myPROJECT Zahlungen", @company.charges.count ]
    @mtypes.each do |t|
      @text = t.mtype
      @anz = @company.mobjects.where('mtype=?',t.mtype).count
      if @anz and @anz > 0
        @stats << [@text, @anz]
      end
    end
    
    @pieData = []
    @pieLabel = []

    @pieLabel << "Werbelinks"
    @pieData << @company.partner_links.count
    
    #@pieLabel << "myPROJECT Zahlungen"
    #@pieData << @company.charges.count

    @mtypes.each do |t|
      #if @company.mobjects.where('mtype=?',t.mtype).count > 0
        @pieLabel << t.mtype
        @pieData << @company.mobjects.where('mtype=?',t.mtype).count
      #end
    end

    if @topic ==   "institutionen_projekte"
        if params[:show]
          @c_show = params[:show]
        else
          @c_show = "kachel"
        end
    end

    if @topic ==   "institutionen_export" or "institutionen_projekte"

        if params[:writeexcel]
          @filename = "public/projectreport_company"+@company.id.to_s+".xls"
        else
          @filename = nil
        end

        if params[:year]
          @c_year = params[:year]
        else
          @c_year = Date.today.year
        end
        if params[:month]
          @c_month = params[:month]
        else
          @c_month = Date.today.month
        end

        if params[:mode]
          @c_mode = params[:mode]
        else
          if @topic == "institutionen_export"
            @c_mode = "Monat"
          end
        end

        if params[:dir] == ">"
          if @c_mode == "Monat"
            if @c_month.to_i == 12
              @c_month =  1
              @c_year = @c_year.to_i + 1
            else
              @c_month = @c_month.to_i + 1
            end
          end
          if @c_mode == "Jahr"
            @c_year = @c_year.to_i + 1
          end
        end
        if params[:dir] == "<"
          if @c_mode == "Monat"
            if @c_month.to_i == 1
              @c_month =  12
              @c_year = @c_year.to_i - 1
            else
              @c_month = @c_month.to_i - 1
            end
          end
          if @c_mode == "Jahr"
            @c_year = @c_year.to_i - 1
          end
        end
        case @c_mode
          when "Monat"
            @date_start = Date.new(@c_year.to_i,@c_month.to_i,1)
            @date_end = @date_start.end_of_month
          when "Jahr"
            @date_start = Date.new(@c_year.to_i,1,1)
            @date_end = Date.new(@c_year.to_i,12,31)
        end
        
    end

  end

  # GET /companies/new
  def new
      @company = Company.new
      @company.name = ""
      @company.user_id = params[:user_id]
      @company.active = true
      @company.status = "OK"
      @company.partner = false
  end

  # GET /companies/1/edit
  def edit
    #@company.status = "changed"
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to user_path(:id => @company.user_id, :topic => "personen_institutionen"), notice: (I18n.t :act_create)
      # redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @us = @company.user_id
    @company.destroy
    redirect_to user_path(:id => @us, :topic => "personen_institutionen"),  notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end
    
    def company_params
      params.require(:company).permit(:partner, :status, :active, :name, :homepage, :mcategory_id, :social, :stichworte, :user_id, :description, :address1, :address2, :address3, :geo_address, :longitude, :latitude, :phone1, :phone2, :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at)
    end

end
