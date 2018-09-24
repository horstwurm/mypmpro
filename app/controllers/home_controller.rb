class HomeController < ApplicationController

protect_from_forgery except: :migrate

def nutzung
end

def index
    @users = User.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_pk = [['Datum','Anzahl']]
    @users.each do |i|
      @anz_pk << [i.datum.to_s, i.summe]
    end

    @companies = Company.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_fk = [['Datum','Anzahl']]
    @companies.each do |i|
      @anz_fk << [i.datum.to_s,  i.summe]
    end

    @objects = Mobject.select("date(created_at) as datum, count(id) as summe").group("date(created_at)")
    @anz_obj = [['Datum','Anzahl']]
    @objects.each do |i|
      @anz_obj << [i.datum.to_s, i.summe]
    end

  if user_signed_in?
    #redirect_to current_user
  end
end

def index1
  if user_signed_in?
    case params[:status] 
      when "einlösen"
        if params[:userticket_id]
          @ticket = UserTicket.find(params[:userticket_id])
          @ticket.status = "eingelöst"
          @ticket.save
        end
      when "reaktivieren"
        if params[:userticket_id]
          @ticket = UserTicket.find(params[:userticket_id])
          @ticket.status = "aktiv"
          @ticket.save
        end
    end
    if params[:me]
      @ticket = UserTicket.where('id=?',params[:me]).first
      if @ticket
        if @ticket.owner_type == "Msponsor"
          if @ticket.ticket.msponsor.company.user.id == current_user.id
            @auth_status = "autorisiert"
          else
            @auth_status = "nicht autorisiert"
            @auth_reason = "nur " + @ticket.ticket.msponsor.company.user.name + " " + @ticket.ticket.msponsor.company.user.lastname + "!"
          end
        end
        if @ticket.owner_type == "Mobject"
          if @ticket.ticket.owner.company.user.id == current_user.id
            @auth_status = "autorisiert"
          else
            @auth_status = "nicht autorisiert"
            @auth_reason = "nur " + @ticket.ticket.owner.company.user.name + " " + @ticket.ticket.owner.company.user.lastname + "!"
          end
        end
        if @ticket.status == "aktiv"
          @ticket_status = "Ticket gültig"
        else
          @ticket_status = "Ticket ungültig"
          @status_reason = "Ticketstatus muss 'aktiv' sein!, ist aber " + @ticket.status 
        end
      end
    end
  else
    redirect_to home_index7_path, notice: "Kein Benutzer angemeldet!"
  end
end

def index2
    @users = User.all.order(last_sign_in_at: :desc).page(params[:page]).per_page(20)
    @usanz = @users.count
end

def services
  session[:page] = nil
end

def index4
    @users = User.all.last
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      if user.latitude != nil and user.longitude != nil
        marker.lat user.latitude
        marker.lng user.longitude
        marker.infowindow "<a href=/users/" + user.id.to_s + ">" + user.name + "</a>"
        if user.avatar 
          marker.picture :url => url_for(user.avatar(:small)), :width => 50, :height => 50
        else
          marker.picture :url => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|", :width => 50, :height => 50
        end
      end
     end
     @hash.push({lat: request.location.latitude, lng: request.location.longitude, infowindow: "img src="+url_for(User.find(1).avatar(:small)) })

@user = current_user
@lat = request.location.latitude
@lng = request.location.longitude 
@text = @lat.to_s + "/" + @lng.to_s
end

def index5
  @test = DonationStat.select("date(created_at) as datum, count(amount) as summe").group("date(created_at)")

  @array = []
  @cat = Category.all
  @cat.each do |c|
    anz = Company.where('category_id=?', c.id).count
    if anz > 0
      hash = Hash.new
      hash = {"label" => c.name, "value" => anz}
      @array << hash
    end
  end
  
  @array.each do |a|
    puts a.to_s
  end
  
end

def index6
  @searches = Search.where('user_id=?', current_user.id).order(:mtype)
end

def index7
 if params[home_index7_path]
   @test = params[home_index7_path][:domain]
 else
   @test = "Veranstaltungen"
 end 
 counter = 0 
 @array = ""
 case @test
  when "Geburtstage Favoriten"
     @users = current_user.favourits
     @anz = @users.count
     @users.each do |u|
          if u.object_name == "User" 
            @user = User.find(u.object_id)
            if @user and @user.dateofbirth

              @caldate = Date.today.year.to_s + "-" + @user.dateofbirth.strftime("%m-%d")
              
              counter = counter + 1
              @array = @array + "{"
              @array = @array + "color : '#ACC550',"
              @array = @array + "textColor : 'white',"
              @array = @array + "title : '" + @user.name + " " + @user.lastname + "', "
              @array = @array + "start : '" + @caldate + "', "
              @array = @array + "url : '" + user_path(:id => @user.id, :topic => "personen_nfo") +"'" 
              @array = @array + "}"
              if current_user.favourits.count >= counter
                @array = @array + ", "
              end  
            end
          end
      end
      
  when "Veranstaltungen", "Crowdfunding", "Aktionen", "Ausschreibungen", "Stellenanzeigen"
    if @test == "Aktionen"
      @mobjects = Mobject.where('mtype=? and msubtype=?', "Angebote", "Aktion")
    else
      @mobjects = Mobject.where('mtype=?', @test)
    end
    @anz = @mobjects.count
    @mobjects.each do |u|
          if u.date_from
            counter = counter + 1
            @array = @array + "{"
            @array = @array + "color : '#ACC550',"
            @array = @array + "textColor : 'white',"
            @array = @array + "title : '" + u.name + "', "
            @array = @array + "start : '" + u.date_from.to_s + "', "
            if u.date_to
              @array = @array + "end : '" + u.date_to.to_s + "', "
            end
            @array = @array + "url : '" + mobject_path(:id => u.id, :topic => "objekte_info") +"'" 
            @array = @array + "}"
            if @mobjects.count >= counter
              @array = @array + ", "
            end  
          end
      end
  end
end
  
def index8
  @mtype = params[:mtype]
  @user_id = params[:user_id]
  @company_id = params[:company_id]
end

def index9
  @categories = Mcategory.select("ctype").distinct
end

def index10
  if user_signed_in?
    
    if params[:day]
      @n = params[:day].to_i
    else
      @n=1
    end
    
    # follow Tickets
    @usertickets = UserTicket.where('user_id=? and (status=? or status=?) and created_at>=?', current_user.id, "übergeben", "persönlich", @n.day.ago).order(created_at: :desc)

    # follow Favoriten
    @favourits = current_user.favourits.where('created_at>=?',@n.day.ago).order(created_at: :desc)

    # follow Termine
    @appointments = Appointment.where('user_id1=? and created_at>=?', current_user.id, @n.day.ago ).order(created_at: :desc)
    
    # follow Transaktionen
    @transactions = current_user.transactions.where('created_at>=?', @n.day.ago ).order(created_at: :desc)
    
    @customers = current_user.customers.order(created_at: :desc)

    # follow eMails
    @emails  = Email.where('m_to=? and created_at>=?', current_user.id, @n.day.ago ).order(created_at: :desc)
    
    # follow Objects from Favouriten
    @mobjects = current_user.mobjects.order(created_at: :desc)

    # follow Searches
    @searches = current_user.searches.order(created_at: :desc)
    
  end    
end

def index11
  if params[:kam_id]
    @campaign = Mobject.find(params[:kam_id])
    @company = @campaign.owner
    @signages = @campaign.mdetails
    @location = nil
  end
  if params[:loc_id]
    @location = Mobject.find(params[:loc_id])
    @company = @location.owner
    @campaigns = SignageCal.where('mstandort=?',params[:loc_id])
    @signages = nil
  end
  
end

def index12
end

def index13
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
end

def index14
  random = Random.new(Time.new.to_i)
  ra1 = rand(100)+1
  
  @anz_obj = []
  for i in 0..ra1
    temp = Hash.new
    temp = {"Nummer"+ i.to_s => i}
    @anz_obj << temp
  end
end

def dashboard_data
    respond_to do |format|
      format.json 
        msg = [{:kategorie => "User", :anzahl => User.all.count},{:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count},{:kategorie => "Publikationen", :anzahl => Mobject.where('mtype=?',"Publikationen").count},{:kategorie => "Artikel", :anzahl => Mobject.where('mtype=?',"Artikel").count},{:kategorie => "Veranstaltungen", :anzahl => Mobject.where('mtype=?',"Veranstaltungen").count}]
        render :json => msg.to_json
    end
end

def arduino
    respond_to do |format|
      format.json 
        msg = []
        msg << {:user => User.where("updated_at > ?", 10.minutes.ago).count}
        msg << {:reg => User.count}
        msg << {:projekte => Mobject.where("mtype=?", "projekte").count}
        msg << {:aufwand => Timetrack.count}
        msg << {:kapa => Planning.count}
        render :json => msg.to_json
    end
end

def dashboard2_data
    respond_to do |format|
      format.json 
        msg = []
        msg << {:kategorie => "User", :anzahl => User.all.count}
        msg << {:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count}
        @cats = Mobject.select("mtype").distinct
        @cats.each do |c|
          count = Mobject.where('mtype=?', c.mtype).count
          if count > 0
            msg << {:kategorie => c.mtype, :anzahl => count}
          end
        end
        render :json => msg.to_json
    end
end

def dashboard_projectdata

  @mobject = Mobject.find(params[:pid])
  @prolist = [@mobject.id]
  @mobject.wo_iterate(@mobject.id, true, @prolist)
  @projects = Mobject.where("mtype=? and id in (?)", "projekte", @prolist)
  msg = []
  @projects.each do |p|
    @kosten = p.timetracks.where('costortime=?',"kosten").sum(:amount)
    @aufwand = p.timetracks.where('costortime=?',"aufwand").sum(:amount)
    if @kosten
      msg << {:id => p.id, :kategorie => "kosten", :summe => @kosten}
    end
    if @aufwand
      msg << {:id => p.id, :kategorie => "aufwand", :summe => @aufwand}
    end 
  end
  respond_to do |format|
    format.json
      render :json => msg.to_json
  end
end

def dashboard
end

def index15
  @question = Question.find(params[:question_id])
  
  if @question.mcategory.name == "text" or @question.mcategory.name == "numerisch" 
    if @question.answers.count == 0
      @a = Answer.new
      @a.question_id = @question.id
      @a.name = "Bitte angeben"
      @a.save
    end  
  end
  
  if params[:user_answer_id]
    @ua = UserAnswer.find(params[:user_answer_id])
    @a = @ua.answer
    
    if @question.mcategory.name == "single"
      @question.answers.each do |qa|
        @uai = UserAnswer.where('user_id=? and answer_id=?', current_user.id, qa.id).first
        if @uai and @uai.checker
          @uai.checker = false
          @uai.save
        end
      end
    end
    if @ua
      if @question.mcategory.name == "multiple"
        if @ua.checker
          @ua.checker = false
        else
          @ua.checker = true
        end
      else
        @ua.checker =true
      end
      @ua.save
    end
  end
end


def index16
  @question = Question.find(params[:question_id])
end

def index17
  if params[:mailgunflag]
    $usemailgun = true
  else
    $usemailgun = false
  end
  #UserMailer.welcome_email(User.last).deliver_now
  redirect_to home_services_path
end

def index18
  if params[:standort]
    @campaigns = SignageCal.where("mstandort=? and date_from<=? and date_to>=?",params[:standort], Date.today, Date.today)
    if @campaigns
      @mob = Mobject.find(params[:standort])
      @owner = @mob.owner
      @standort = @mob
      @campanz = @campaigns.count
      @camp = "("
      @campaigns.each do |c|
        @camp = @camp + Mobject.find(c.mkampagne).name + " "
      end
      @camp = @camp + ")"
    else
      @campanz = 0
    end
  end
  if params[:kampagne]
    @campaigns = SignageCal.where("mkampagne=?",params[:kampagne])
    @mob = Mobject.find(params[:kampagne])
    @kampagne = @mob
    @owner = @mob.owner
  end
end

def index20
  if params[:company_id] and params[:mtype]
    if !user_signed_in?
      redirect_to company_path(:id => params[:company_id], :topic => "objekte_sponsorantraege"), notice: (I18n.t :firstsignin)
    else
      @company_id = params[:company_id]
      @mtype = params[:mtype]
      @companies = current_user.companies
    end
  end
end

def import
    path=File.join(Rails.root, "/app/assets/images/mig2017.xlsx")
    workbook = Creek::Book.new path
    @worksheets = workbook.sheets
end

def Umfragen_data

    @question = Question.find(params[:question_id])
  
    @array = []
    @question.answers.each do |qa|
      
      anz = qa.user_answers.where('checker=?',true).count
      
      hash = Hash.new
      hash = {:kategorie => qa.name, :anzahl => anz.to_s}
      @array << hash
      
    end

    #msg = [{:kategorie => "User", :anzahl => User.all.count},{:kategorie => "UserOnline", :anzahl => User.where("updated_at > ?", 10.minutes.ago).count},{:kategorie => "Publikationen", :anzahl => Mobject.where('mtype=?',"Publikationen").count},{:kategorie => "Artikel", :anzahl => Mobject.where('mtype=?',"Artikel").count},{:kategorie => "Veranstaltungen", :anzahl => Mobject.where('mtype=?',"Veranstaltungen").count}]

    respond_to do |format|
      format.json 
        render :json => @array.to_json
    end

end

def dashboard_project
end

def readLastValue
  msg = []
  if params[:sensor]
    @sensor = Mobject.find(params[:sensor])
    @iot = @sensor.sensors.last
    if @iot
      if @iot.value
          msg << {:datum => @iot.created_at.strftime("%H:%m"), :wert => @iot.value}
      end
      if @iot.svalue
          msg << {:datum => @iot.created_at.strftime("%H:%m"), :wert => @iot.svalue}
      end
      if @iot.bvalue
          msg << {:datum => @iot.created_at.strftime("%H:%m"), :wert => @iot.bvalue}
      end
    else
      msg << {:datum => Date.today.strftime("%H:%m"), :wert => 0}
    end
  else
      msg << {:datum => Date.today.strftime("%H:%m"), :wert => 0}
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
    format.html
  end
end

def readsensordata
  if params[:sensor]
    @sensor = Mobject.find(params[:sensor])
    @iots = @sensor.sensors.order(:created_at)
  else
    @iots = Sensor.all.order(:created_at)
  end
  respond_to do |format|
    format.json 
      msg = []
      #msg << {:datum => "Datum", :wert => "Wert"}
      @iots.each do |i|
        msg << {:datum => i.created_at.strftime("%H:%m"), :wert => i.value}
      end
      render :json => msg.to_json
  end
end

def writesensordata
  if params[:sensor] and params[:value]
    @sensor = Sensor.new
    @sensor.mobject_id = params[:sensor]
    @sensor.value = params[:value]
    @sensor.save
  end
  @sensors = Mobject.find(params[:sensor]).sensors

  #delete Anzahl > ??
  delanz = 100
  if @sensors
    if @sensors.count > delanz
      @sensors.order('created_at ASC').limit(@sensors.count-delanz).destroy_all        
      @sensors = Mobject.find(params[:sensor]).sensors
    end
  end

  msg = []
  if @sensors and @sensors.count > 0 
    msg << {:type => "Anzahl", :anzahl => @sensors.count}
  else
    msg << {:type => "Anzahl", :anzahl => 0}
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end

def readusernotes
  if params[:user]
    @user = User.find(params[:user])
    @notes = @user.notes.order(:message)
  end
  respond_to do |format|
    format.json 
      msg = []
      @notes.each do |i|
          msg << {:message => @user.name+"_"+@user.lastname+" "+i.message}
      end
      render :json => msg.to_json
  end
end

def writeusernotes
  if params[:user] and params[:message]
    @ns = User.find(params[:user]).notes.where('message=?', params[:message])
    if !@ns or @ns.count == 0
      @note = Note.new
      @note.user_id = params[:user]
      @note.message = params[:message]
      @note.datum=Date.today
      @note.uhrzeit=8000
      @note.save
    end
  end
  respond_to do |format|
    format.json 
      msg = []
      msg << {:status => "ok"}
      msg << {:anzahl => User.find(params[:user]).notes.count }
      render :json => msg.to_json
  end
end
def test
end

def readuser
  if params[:nname] and params[:vname]
    @ns = User.where('lastname=? and name=?',params[:nname], params[:vname]).first
  else 
    if params[:nname]
      @ns = User.where('lastname=?',params[:nname]).first
    end
  end
  respond_to do |format|
    format.json 
      msg = []
      if @ns
        msg << {:name => @ns.name + " " + @ns.lastname}
        msg << {:nummer => @ns.id }
      else
        msg << {:name => "unknown"}
        msg << {:nummer => -1 }
      end
      render :json => msg.to_json
  end
end

def writeuserpos
  if params[:user] and params[:longitude] and params[:latitude]
      @pos = UserPosition.new
      @pos.user_id = params[:user]
      @pos.longitude = params[:longitude]
      @pos.latitude = params[:latitude]
      @pos.save
  end
  respond_to do |format|
    format.json 
      msg = []
      msg << {:status => "ok"}
      msg << {:anzahl => User.find(params[:user]).user_positions.count }
      render :json => msg.to_json
  end
end

def test
         @locs = []
         @wins = []
         @user=User.find(1);
         @user.user_positions.each do |u|
    
            if u.longitude and u.latitude
           
              @locs << [u.user.fullname, u.latitude, u.longitude]
              if u.user.avatar_file_name 
                img = url_for(u.user.avatar(:small))
              else
                img = File.join(Rails.root, "/app/assets/images/no_pic.jpg")
              end
              #@wins << ["'<img src=" + img + " <br><h3>" + u.fullname + "</h3><p>" + u.geo_address + "</p>'"]
              @wins << ["'<img src=" + img + " <br><h3>" + u.user.fullname + "</h3></p>'"]
    
            end
          end

end

def alexa
  case params[:intent]
    when "Projektinfo"
      @p = Mobject.where('LOWER(name) LIKE ?',"%#{params[:slot].downcase}%").first
      if @p
        response = "Projekt gefunden"
        response = {:slot => params[:slot], :projekt => "gefunden", :name => @p.name, :owner => @p.owner.name, :stunden => @p.timetracks.where('costortime=?',"aufwand").sum(:amount), :kosten => @p.timetracks.where('costortime=?',"kosten").sum(:amount)}
      else
        response = {:projekt => "Projekt nicht gefunden"}
      end
    else
      response = {:message => "wrong intent"}
  end
  respond_to do |format|
    format.json 
      #msg = {:message => response}
      render :json => response.to_json
  end
end

def writeiot
  if params[:owner_id] and params[:owner_type] and params[:frame] and params[:name] and params[:value]
      @iot = Iot.new
      @iot.owner_id = params[:owner_id]
      @iot.owner_type = params[:owner_type]
      @iot.frame = params[:frame]
      @iot.name = params[:name]
      @iot.value = params[:value]
      @iot.save
  end
  respond_to do |format|
    format.json 
      msg = {:anzahl => Iot.where('owner_id=? and owner_type=? and frame=? and name=?', params[:owner_id], params[:owner_type], params[:frame], params[:name]).count}
      render :json => msg.to_json
  end
end

def readiot
  if params[:owner_id] and params[:owner_type] and params[:frame] and params[:name]
      @iot = Iot.where('owner_id=? and owner_type=? and frame=? and name=?', params[:owner_id], params[:owner_type], params[:frame], params[:name]).last
      if @iot 
        msg = {value: @iot.value}
      else
        msg = {value: "undefined"}
      end
    else
        msg = {value: "invalid request"}
  end
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end

def writeimage
  path=File.join(Rails.root, "/app/assets/images/")
  if params[:mobject_id] and params[:image_text]
      @mobject = Mobject.find(params[:mobject_id])
      encoded_string = params[:image_text]
      File.open(path+"base64test.jpg", "wb") do |file|
        file.write(Base64.decode64(encoded_string))
      end
      @mdetails = Mdetail.new
      @mdetails.mobject_id = params[:mobject_id]
      @mdetails.name = "Test"
      @mdetails.avatar = File.open(path+'base64test.jpg', 'rb')
      @mdetails.save
  end
  respond_to do |format|
    format.json 
      msg = {:name => @mobject.name, :anzahl => @mobject.mdetails.count}
      render :json => msg.to_json
  end
end

def temptest
end

def switch
  if params[:mobject_id]
    @mobject = Mobject.find(params[:mobject_id])
    @sensor = @mobject.sensors.last.value
    if !@sensor
      val = 1
    else
      if @sensor == 1
        val = 0
      else
        val = 1
      end
    end
    @sensor = Sensor.new
    @sensor.mobject_id = params[:mobject_id]
    @sensor.value = val
    @sensor.save
  end
  msg = {:id => @mobject.id, :state => val}
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end

def readswitch
  if params[:mobject_id]
    @mobject = Mobject.find(params[:mobject_id])
    @sensor = @mobject.sensors.last
    if !@sensor
      val = 0
    else
      val = @sensor.value
    end
  end
  msg = {:id => @mobject.id, :state => val}
  respond_to do |format|
    format.json 
      render :json => msg.to_json
  end
end

def migrate
  if params[:topic] == "user"
    @user = JSON.parse(open("https://mytgcloud.herokuapp.com/home/getUser.json").read)
    
    if params[:actioncode] == "add"
      @user.each do |p|
        if p["email"] == params[:email] or params[:scope] == "all"
          u = User.new 
          u.email = p["email"] 
          u.password = "password" 
          u.name = p["name"] 
          u.lastname = p["lastname"] 
          u.address1 = p["address1"] 
          u.address2 = p["address2"] 
          u.address3 = p["address3"] 
          u.phone1 = p["phone1"]
          u.phone2 = p["phone2"] 
          u.org = p["org"] 
          u.costinfo = p["costinfo"] 
          u.rate = p["rate"] 
          u.status = "OK" 
          u.anonymous = false 
          u.active = true
          if u.email == "horst.wurm@bluewin.ch" 
            u.superuser=true
          end 
          u.save
        end
      end
    end
    
    if params[:actioncode] == "del"
      @user.each do |u|
        if u["email"] == params[:email]
          User.where('email=?',params[:email]).first.destroy
        end
      end
    end

  end

  if params[:topic] == "gruppen"
    @gruppen = JSON.parse(open("https://mytgcloud.herokuapp.com/home/getUserGroups.json").read)
    if params[:actioncode] == "addgroup"
        u = Mobject.new
        u.owner_id = User.where('email=?',params[:email]).first.id
        u.owner_type = "User"
        u.mtype="gruppen"
        u.mcategory_id = (Mcategory.where('name=?',"private").first).id
        u.name = params[:group_name] 
        u.status = "OK" 
        u.active = true
        u.save
    end

    if params[:actioncode] == "delgroup"
      @mobject = Mobject.where('name=?',params[:group_name]).first
      if @mobject
        @mobject.destroy
      end
    end

    if params[:actioncode] == "addmember"
      @members = JSON.parse(open("https://mytgcloud.herokuapp.com/home/getGroupMembers.json?group_name="+params[:group_name]).read)
      @mobject = Mobject.where('name=?',params[:group_name]).first
      if @mobject
        @members.each do |p|
          u=Madvisor.new
          u.mobject_id = @mobject.id
          u.user_id = User.where('email=?',p["email"]).first.id
          u.role="gruppen"
          u.grade = "Gruppenmitglied" 
          u.save
        end
      end
    end
    
    if params[:actioncode] == "delmember"
      @mobject = Mobject.where('name=?',params[:group_name]).first
      if @mobject
        @mobject.madvisors.where("role=?","gruppen").destroy_all
      end
    end

  end

  if params[:topic] == "projekte"
    @projekte = JSON.parse(open("https://mytgcloud.herokuapp.com/home/getPP.json").read)
    if params[:actioncode] == "add"
      @projekte.each do |p|
        if p["name"] == params[:oname]
          @m = Mobject.new
          @m.mcategory_id = (Mcategory.where('name=?',"CHANGE").first).id
          @m.mtype = "projekte"
          @m.parent = 0
          @m.owner_type = "Company"
          @m.owner_id = (Company.where('name=?',"Thurgauer Kantonalbank").first).id
          @m.name = p["name"]
          @m.description = p["description"]
          @m.date_from = p["date_from"]
          @m.date_to = p["date_to"]
          @m.costinfo = p["costinfo"]
          @m.orderinfo = p["orderinfo"]
          @m.sum_paufwand_plan = p["sum_paufwand_plan"]
          @m.sum_paufwand_ist = p["sum_paufwand_ist"]
          @m.sum_pkosten_plan = p["sum_pkosten_plan"]
          @m.sum_pkosten_ist = p["sum_pkosten_ist"]
          @m.status = "OK"
          @m.termin = "MID"
          @m.kosten = "MID"
          @m.qualitaet = "MID"
          @m.active = true
          @m.save
        end
      end
    end
    
    if params[:actioncode] == "del"
      @projekte.each do |p|
        if p["name"] == params[:oname]
          @m = Mobject.where('name=?', params[:oname]).first
          if @m
            @m.destroy
          end
        end
      end
    end

    if params[:actioncode] == "plannings"
      @plans = JSON.parse(open("https://mytgcloud.herokuapp.com/home/getPlan.json?projekt_id="+params[:id].to_s).read) 
      
      @temp = Mobject.find(params[:newid])
      if @temp
        @temp.plannings.destroy_all
      end
      @array = []
      @plans.each do |s|
        if User.where('email=?',s["user_id"]).first
        m = Planning.new
        m.user_id = (User.where('email=?',s["user_id"]).first).id
        m.mobject_id = params[:newid]
        m.costortime = s["costortime"]
        m.description = s["description"]
        m.amount = s["amount"]
        m.jahrmonat = s["jahrmonat"]
        m.jahr = m.jahrmonat[0,4]
        m.monat = m.jahrmonat[5,7]
        m.save
        
        user_id = (User.where('email=?',s["user_id"]).first).id
        mobject_id = params[:newid]
        @re = Madvisor.where("user_id=? and mobject_id=? and role=?", m.user_id, m.mobject_id, "projekte").first
        if !@re
          @array << user_id.to_s + " " + mobject_id.to_s + " " + "projekte"
          c=Madvisor.new
          c.user_id=user_id
          c.mobject_id=mobject_id
          c.role="projekte"
          c.grade="Projektmitarbeiter"
          c.save
        end
        end
      end
    end

    if params[:actioncode] == "timetracks"

      #@tt = JSON.parse(open("https://mytgcloud.herokuapp.com/home/getRep.json?projekt_id="+params[:id].to_s).read) 
      @tt = JSON.parse(open("https://mytgcloud.herokuapp.com/home/getRepKum.json?projekt_id="+params[:id].to_s).read) 
      @temp = Mobject.find(params[:newid])
      if @temp
        @temp.timetracks.destroy_all
      end
      @tt.each do |s|
        if User.where('email=?',s["user_id"]).first
        m = Timetrack.new
        m.user_id = (User.where('email=?',s["user_id"]).first).id
        m.mobject_id = params[:newid]
        m.costortime = s["costortime"]
        #m.activity = s["activity"]
        m.activity ="Sammelbuchung Migration"
        m.amount = s["amount"]
        #m.datum = s["datum"]
        m.datum = (s["jahrmonat"] + "-01")
        m.jahrmonat = s["jahrmonat"]
        m.save
        
        user_id = (User.where('email=?',s["user_id"]).first).id
        mobject_id = params[:newid]
        @record = Madvisor.where("user_id=? and mobject_id=? and role=?", m.user_id, m.mobject_id, "projekte").first
        if !@record
          c=Madvisor.new
          c.user_id=m.user_id
          c.mobject_id=m.mobject_id
          c.role="projekte"
          c.grade="Projektmitarbeiter"
          c.save
        end
        end
      end
    end

  end

end

def migrateDo
  if params[:data_value]
    @data = params[:data_value]
    m = Mobject.new
    m.name = params[:data_value]
    m.mcategory_id = 1
    m.owner_id = 1
    m.owner_type = "Company"
    m.online_pub=true
    m.parent=0
    m.mtype = "projekte"
    m.status="OK"
    m.active = true
    m.save
  else
    @data = "not found!"
  end
  respond_to do |format|
    format.json 
      render :json => "ok".to_json
  end
end

def pmalexa
  case params[:intent]
    when "Projektinfo"
      @p = Mobject.where('LOWER(name) LIKE ?',"%#{params[:slot].downcase}%").first
      if @p
        response = "Projekt gefunden"
        response = {:slot => params[:slot], :projekt => "gefunden", :name => @p.name, :stunden => @p.timetracks.where('costortime=?',"aufwand").sum(:amount), :kosten => @p.timetracks.where('costortime=?',"kosten").sum(:amount)}
      else
        response = {:projekt => "Projekt nicht gefunden"}
      end
    else
      response = {:message => "wrong intent"}
  end
  respond_to do |format|
    format.json 
      #msg = {:message => response}
      render :json => response.to_json
  end
end

def getProjects
  @projects = Mobject.where('mtype=? and active=?',"projekte", true)
  plist = []
  @projects.each do |p|
    plist << p.id
  end
  if !plist
    response = {:message => "keine Projekte gefunden"}
  else
    response = {:ids => plist}
  end
  respond_to do |format|
    format.json 
      #msg = {:message => response}
      render :json => response.to_json
  end
end

def getProject
  @project = Mobject.find(params[:mobject_id])
  if !@project.gesamtstatus
    @project.gesamtstatus = "OK"
    @project.save
  end
  if @project
    response = {:name => @project.name, :laufzeit => (Date.today - @project.date_from).to_i, :termin => @project.termin, :kosten => @project.kosten, :qualitaet => @project.qualitaet, :gesamtstatus => @project.gesamtstatus, :stunden_plan => @project.sum_paufwand_plan, :kosten_plan => @project.sum_pkosten_plan, :stunden_ist => @project.sum_paufwand_ist, :kosten_ist => @project.sum_pkosten_ist}
  else
    response = {:projekt => "Projekt nicht gefunden"}
  end
  respond_to do |format|
    format.json 
      #msg = {:message => response}
      render :json => response.to_json
  end
end

end