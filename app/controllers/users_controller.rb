class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def webmaster
    if @user.webmaster == true
      @user.webmaster = false
    else
      @user.webmaster = true
    end
    @user.save
    redirect_to @user, notice: 'Webmaster '  
  end
  
  def index
    @controller_name = controller_name
    if params[:page] != nil
      session[:page] = params[:page]
    end
    if params[:filter_id]
      @filter_id = params[:filter_id]
    end
    @filter = params[:filter_id]
    @users = User.search(params[:filter_id],params[:search]).order(created_at: :desc).page(params[:page]).per_page(50)
    @usanz = @users.count

    if params[:mode]
      @mode = params[:mode]
    end

    if params[:mode] == "deputy"
      if params[:user_id]
        @owner_id = params[:user_id]
        @owner_type = "User"
      end
      if params[:company_id]
        @owner_id = params[:company_id]
        @owner_type = "Company"
      end
    end

    if params[:mode] == "projekte" or "gruppen"
      @mobject_id = params[:mobject_id]
    end

  end
  
  # GET /users/1
  # GET /users/1.json
  def show

   if params[:topic]
     @topic = params[:topic]
   else 
     @topic = "personen_info"
   end 

    case @topic

      when "personen_info"
        @mtypes = Mobject.select("mtype").distinct
        @stats = [["Aktivtäten","Anzahl"]]
        @stats << ["Institutionen", @user.companies.count]
        @stats << ["Zeiterfassungen", @user.timetracks.count ]
        @stats << ["Ressourcenplanungen", @user.plannings.count ]
        @stats << ["myPROJECT Zahlungen", @user.charges.count]
        @stats << ["Messages", Email.where('m_to=? or m_from=?', @user.id, @user.id).count ]
        @stats << ["Abfragen", @user.searches.count]
        @mtypes.each do |t|
          @text = t.mtype
          @anz = @user.mobjects.where('mtype=?',t.mtype).count
          @stats << [@text, @anz]
        end
        
      when "personen_ressourcenplanung", "personen_zeiterfassung", "personen_export"
        if params[:writeexcel]
          @filename = "public/projectreport_user"+@user.id.to_s+".xls"
        else
          @filename = nil
        end
        if params[:tdatum]
          @c_datum = params[:tdatum].to_date
        else
          @c_datum = Date.today
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
          if @topic == "personen_zeiterfassung"
            @c_mode = "Datum"
            #@c_datum = Date.today
          end
          if @topic == "personen_ressourcenplanung"
            @c_mode = "Jahr"
          end
          if @topic == "personen_export"
            @c_mode = "Monat"
          end
        end
        if params[:scope]
          @c_scope = params[:scope]
        else
          @c_scope = "aufwand"
        end
        
        if params[:dir] == ">"
          if @c_mode == "Datum"
            @c_datum = @c_datum.to_date + 1
          end
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
          if @c_mode == "Datum"
            @c_datum = @c_datum.to_date - 1
          end
          if @c_mode == "Woche"
            if @c_week.to_i == 1
              @c_week =  52
              @c_year = @c_year.to_i - 1
            else
              @c_week = @c_week.to_i - 1
            end
          end 
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
        
        myobs = []
        @user.madvisors.each do |a|
          myobs << a.mobject_id 
        end
        @mymobjects = Mobject.where('mtype=? and id IN (?)',"projekte", myobs).order(:name)

      when "personen_zugriffsberechtigungen"
        if params[:credential_id]
          @c = Credential.find(params[:credential_id])
          if @c
            #@c.edit
            if @c.access
              @c.access=false
            else
              @c.access=true
            end
            @c.save
          end
        end

    end
    
    if params[:header] != nil and params[:body] != nil
      UserMailer.send_message(params[:id], params[:header], params[:body]).deliver_now
    end
  
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        
        # send eMail
        #puts "ATTENTION ATTENTION here we go...."
        UserMailer.welcome_email(@user).deliver_now
        
        format.html { redirect_to users_url, notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
        redirect_to @user, notice: (I18n.t :act_update)
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_path, notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:costinfo, :rate, :calendar, :time_from, :time_to, :status, :dateofbirth, :email, :active, :anonymous, :webmaster, :userid, :lastname, :name, :address1, :address2, :address3, :geo_address, :longitude, :latitude, :phone1, :phone2, :org, :title, :costrate, :costinfo1, :avatar )
    end
    
end
