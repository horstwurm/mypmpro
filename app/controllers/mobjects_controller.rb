class MobjectsController < ApplicationController
  before_action :set_mobject, only: [:show, :edit, :update, :destroy]

  # GET /mobjects
  def index

    if params[:edition_id]
      session[:edition_id] = params[:edition_id]
      @edition_id = params[:edition_id]
    end

    @controller_name = controller_name
    
    if params[:set_part_id]
      @anmeldung = current_user.madvisors.where('mobject_id=? and role=?', params[:set_part_id],"eventteilnehmer").first
      if !@anmeldung
        @madvisor = Madvisor.new
        @madvisor.user_id = current_user.id
        @madvisor.mobject_id = params[:set_part_id]
        @madvisor.role = "eventteilnehmer"
        @madvisor.grade = "Teilnehmer"
        @madvisor.save
      end
    end
    if params[:del_part_id]
      @anmeldung = current_user.madvisors.where('mobject_id=? and role=?', params[:del_part_id], "eventteilnehmer").first
      if @anmeldung
        @anmeldung.destroy
      end
    end
    
    if params[:mtype]
      session[:mtype] = params[:mtype]
      case params[:mtype]
        when "crowdfunding"
          if params[:msubtype]
            session[:msubtype] = params[:msubtype]
          end
        else
            session[:msubtype] = nil
      end
    end

    if session[:mtype] == "projekte"
      if params[:parent]
        session[:parent] = params[:parent]
      end
    else
      session[:parent] = nil
    end

    @mobjects = Mobject.search(current_user, nil, nil, params[:filter_id], session[:mtype], session[:msubtype], params[:search], params[:parent]).order(created_at: :desc).page(params[:page]).per_page(10)
    @mobanz = @mobjects.count
    @mtype = session[:mtype]
    @msubtype = session[:msubtype]
    @param = params[:filter_id]
    @search = params[:search]

     counter = 0 
     @locs = []
     @wins = []
     @mobjects.each do |u|

        if u.longitude and u.latitude and u.geo_address
       
          @locs << [u.name, u.latitude, u.longitude]

          if u.mdetails.count > 0
            if u.mdetails.first.avatar_file_name 
              img = url_for(u.mdetails.first.avatar(:small))
            else
              img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
            end
          else
            img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
          end
          @wins << ["'<img src=" + img + " <br><h3>" + u.name + "</h3><p>" + u.geo_address + "</p>'"]

        end

        counter = counter + 1
      end

  end

  # GET /mobjects/1
  def show
    if params[:delsensordata]
      @mobject.sensors.destroy_all
    end
    
    if !params[:topic]
      if @mobject.mtype == "publikationen"
        @topic = "objekte_ausgaben"
      else
        @topic = "objekte_info"
      end
    else
      @topic = params[:topic]
    end

    if params[:edition_id]
      session[:edition_id] = params[:edition_id]
      @edition_id = params[:edition_id]
    end

    if @topic == "objekte_cfstatistik"
      @mobjects_anz = Mstat.select("date(created_at) as datum, count(amount) as summe").where('mobject_id = ?', @mobject.id).group("date(created_at)")
      @mobjects_bet = Mstat.select("date(created_at) as datum, sum(amount) as summe").where('mobject_id = ?', @mobject.id).group("date(created_at)")
  
      @anz_s = [["Datum", "Anzahl TRX"]]
      @mobjects_anz.each do |i|
        @anz_s << [i.datum.to_s, i.summe]
      end
      @bet_s = [["Datum", "Betrag"]]
      @mobjects_bet.each do |i|
        @bet_s << [i.datum.to_s, i.summe]
      end
    end
    
    if @topic == "objekte_kalendervermietungen"
     counter = 0 
     @array = ""
     @cals = @mobject.mcalendars
     @anz = @cals.count
     @cals.each do |c|
  
        time_from = c.time_from.to_s
        if c.time_from.to_s.length == 1
          time_from = "0"+c.time_from.to_s
        end
        time_to = c.time_to.to_s
        if c.time_to.to_s.length == 1
          time_to = "0"+c.time_to.to_s
        end
        @calstart = c.date_from.strftime("%Y-%m-%d")+"T"+time_from+":00"
        @calend = c.date_to.strftime("%Y-%m-%d")+"T"+time_to+":00"
        
        counter = counter + 1
        @array = @array + "{"
        if c.confirmed
          @array = @array + "color: '#ACC550',"
        else
          @array = @array + "color: '#61A6A7',"
        end
        @array = @array + "textColor: 'white',"
        @array = @array + "title: '" + c.user.name + " " + c.user.lastname + "', "
        @array = @array + "start: '" + @calstart + "', "
        @array = @array + "end: '" + @calend + "', "
        @array = @array + "url: '" + user_path(:id => c.user.id, :topic => "personen_info") +"'" 
        @array = @array + "}"
        if @cals.count >= counter
          @array = @array + ", "
        end
        
     end
  end
   
   if @topic == "objekte_auftragscontrolling"
      if params[:export]
        @export = true
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
        @c_mode = "Jahr"
      end
      if params[:scope]
        @c_scope = params[:scope]
      else
        @c_scope = "aufwand"
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
        when "alles"
      end
      
    end

    if @topic == "objekte_ressourcenplanung"
        if params[:export]
          @export = true
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
        if params[:week]
          @c_week = params[:week]
        else
          @c_week = Date.today.cweek
        end
        
        if params[:mode]
          @c_mode = params[:mode]
        else
          @c_mode = "Jahr"
        end
        if params[:scope]
          @c_scope = params[:scope]
        else
          @c_scope = "aufwand"
        end
        
        if params[:dir] == ">"
          if @c_mode == "Woche"
            if @c_week.to_i == 52
              @c_week =  1
              @c_year = @c_year.to_i + 1
            else
              @c_week = @c_week.to_i + 1
            end
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
          when "alles"
        end
      end
      
      if @topic == "objekte_fragen"
        if params[:dir]
          
          @ques=[]
          @mobject.questions.order(:sequence).each do |q|
            h = Hash.new
            h = {:id => q.id, :seq => q.sequence}
            @ques << h
          end

          @myq = Question.find(params[:q_id])
          if params[:dir] == "left"

            if @myq and @myq.sequence > 1

              @myq.sequence = @myq.sequence - 1
              @myq.save

              index = -1
              for i in 0..@ques.length-1
                if @myq.id == @ques[i][:id]
                  index = i-1
                end
              end
              if index > -1
                @myq2 = Question.find(@ques[index][:id])
                if @myq2
                  @myq2.sequence = @myq2.sequence + 1
                  @myq2.save
                end
              end

            end

          end

        end
      end

      if @topic == "objekte_details" and (@mobject.mtype == "artikel")

        if params[:dir]
          
          @details =[]
          @mobject.mdetails.order(:sequence).each do |q|
            h = Hash.new
            h = {:id => q.id, :seq => q.sequence}
            @details << h
          end

          @myd = Mdetail.find(params[:d_id])
          
          if params[:dir] == "left"

            if @myd and @myd.sequence > 0

              @myd.sequence = @myd.sequence - 1
              @myd.save

              index = -1
              for i in 0..@details.length-1
                if @myd.id == @details[i][:id]
                  index = i-1
                end
              end

              if index > -1
                @myd2 = Mdetail.find(@details[index][:id])
                if @myd2
                  @myd2.sequence = @myd2.sequence + 1
                  @myd2.save
               end
              end

            end

          end

        end
      end

  if @topic == "objekte_signcal"
      if params[:confirm_id]
        @cal = SignageCal.find(params[:confirm_id])
        if @cal
          @cal.confirmed = true
          @cal.save
        end
      end
      if params[:noconfirm_id]
        @cal = SignageCal.find(params[:noconfirm_id])
        if @cal
          @cal.confirmed = false
          @cal.save
        end
      end

      counter = 0 
      @array = ""
      if @mobject.mtype == "standorte"
        @cals = SignageCal.where('mstandort=?', @mobject.id)
        session[:signage_cal_mode] = "loc"
      end
      if @mobject.mtype == "kampagnen"
        @cals = SignageCal.where('mkampagne=?', @mobject.id)
        session[:signage_cal_mode] = "kam"
      end
      if @cals
        @anz = @cals.count
        @cals.each do |c|
          
          if @mobject.mtype == "kampagnen"
            @obj = Mobject.find(c.mstandort)
          end
          if @mobject.mtype == "standorte"
            @obj = Mobject.find(c.mkampagne)
          end

          info = '<i class="glyphicon glyphicon-calender"></i>'
  
          time_from = c.time_from.to_s
          if c.time_from.to_s.length == 1
            time_from = "0"+c.time_from.to_s
          end
          time_to = c.time_to.to_s
          if c.time_to.to_s.length == 1
            time_to = "0"+c.time_to.to_s
          end
          @calstart = c.date_from.strftime("%Y-%m-%d")+"T"+time_from+":00"
          @calend = c.date_to.strftime("%Y-%m-%d")+"T"+time_to+":00"

          @calstart = c.date_from.strftime("%Y-%m-%d")
          @calend = c.date_to.strftime("%Y-%m-%d")
          
          counter = counter + 1
          @array = @array + "{"
          @array = @array + "color: '#ACC550',"
          @array = @array + "textColor: 'white',"
          @array = @array + "info: '" + info + "', "
          @array = @array + "title: '" + @obj.name + "', "
          @array = @array + "start: '" + @calstart + "', "
          @array = @array + "end: '" + @calend + "', "
          if @loc
            @array = @array + "url: '" + mobject_path(:id => c.mkampagne, :topic => "objekte_info") +"'" 
          end
          if @kam
            @array = @array + "url: '" + mobject_path(:id => c.mstandort, :topic => "objekte_info") +"'" 
          end
          @array = @array + "}"
          if @cals.count >= counter
            @array = @array + ", "
          end
      end
    end
  end
    
  end

  # GET /mobjects/new
  def new
    @mobject = Mobject.new
    @mobject.status = "OK"
    @mobject.eventpart = false
    @mobject.mtype = params[:mtype]
    case @mobject.mtype
      when "angebote"
        @mobject.msubtype = "aktion"
      when "kleinanzeigen", "stellenanzeigen"
        @mobject.msubtype = "anbieten"
      when "crowdfunding"
        @mobject.msubtype = "spenden"
    end
    @mobject.mcategory_id = params[:msubtype]
    @mobject.active = true
    @mobject.social = false
    @mobject.online_pub = false
    @mobject.name = @mobject.mtype
    @mobject.description = "Beschreibung..."
    @mobject.homepage = "www.xyz.ch"
    @mobject.price_reg = 0
    @mobject.price_new = 0
    @mobject.date_from = Date.today
    @mobject.date_to = Date.today+30
    @mobject.time_from = 7
    @mobject.time_to = 18
    @mobject.amount = 10000.00
    @mobject.price = 100.00
    @mobject.reward = ""
    @mobject.interest_rate = 5
    @mobject.due_date = Date.today + 365
    @mobject.sum_amount = 0
    @mobject.sum_rating = 0
    @mobject.sum_pkosten_ist = 0
    @mobject.sum_pkosten_plan = 100000
    @mobject.sum_paufwand_ist = 0
    @mobject.sum_paufwand_plan = 100
    @mobject.quality = "hoch"
    @mobject.risk = "tief"
    @mobject.maxi = 100
    @mobject.mini = 0
    @mobject.alert = 80
    @mobject.alertlow = false

    if params[:parent]
      @mobject.parent = params[:parent].to_i
    else
      @mobject.parent = 0
    end
    if params[:user_id]
      @mobject.owner_id = params[:user_id]
      @mobject.owner_type = "User"
    end
    if params[:company_id]
      @mobject.owner_id = params[:company_id]
      @mobject.owner_type = "Company"
    end
    @mobject.address1 = @mobject.owner.address1
    @mobject.address2 = @mobject.owner.address2
    @mobject.address3 = @mobject.owner.address3
    @mobject.geo_address = @mobject.owner.geo_address
    @mobject.longitude = @mobject.owner.longitude
    @mobject.latitude = @mobject.owner.latitude

  end

  # GET /mobjects/1/edit
  def edit
  end

  # POST /mobjects
  def create
    @mobject = Mobject.new(mobject_params)

    if @mobject.save
      redirect_to @mobject, notice: (I18n.t :act_create)
    else
      render :new
    end
  end

  # PUT /mobjects/1
  def update
    if @mobject.update(mobject_params)
      redirect_to @mobject, notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /mobjects/1
  def destroy
    @ownerid = @mobject.owner_id
    @ownertype = @mobject.owner_type
    @mtype = @mobject.mtype
    @msubtype = @mobject.msubtype
    @mobject.destroy
    if @ownertype == "User"
      redirect_to user_path(:id => @ownerid, :topic => "personen_"+@mtype), notice: (I18n.t :act_delete)
    else
      redirect_to company_path(:id => @ownerid, :topic => "institutionen_"+@mtype), notice: (I18n.t :act_delete)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mobject
      @mobject = Mobject.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def mobject_params
      params.require(:mobject).permit(:mini, :maxi, :alert, :alertlow, :sum_paufwand_ist, :sum_pkosten_ist, :sum_paufwand_plan, :sum_pkosten_plan, :risk, :quality, :costinfo, :parent, :online_pub, :eventpart, :owner_id, :owner_type, :mtype, :msubtype, :mcategory_id, :company_id, :user_id, :status, :name, :description, :reward, :interest_rate, :due_date, :date_from, :date_to, :time_from, :time_to, :days, :amount, :price, :tasks, :skills, :offers, :social, :price_reg, :price_new, :active, :keywords, :homepage, :address1, :address2, :address3, :latitude, :longitude, :geo_address)
    end

end
