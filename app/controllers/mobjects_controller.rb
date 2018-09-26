class MobjectsController < ApplicationController
  before_action :set_mobject, only: [:show, :edit, :update, :destroy]

  # GET /mobjects
  def index

    @controller_name = controller_name
    
    if params[:mtype]
      session[:mtype] = params[:mtype]
    end

    if session[:mtype] == "projekte"
      if params[:parent]
        session[:parent] = params[:parent]
      end
    else
      session[:parent] = nil
    end
    if params[:filter_id]
      @filter_id = params[:filter_id]
    end

    @mobjects = Mobject.search(current_user, nil, nil, params[:filter_id], session[:mtype], session[:msubtype], params[:search], params[:parent]).order(created_at: :desc).page(params[:page]).per_page(50)
    @mobanz = @mobjects.count
    @mtype = session[:mtype]
    @msubtype = session[:msubtype]
    @param = params[:filter_id]
    @search = params[:search]

  end

  # GET /mobjects/1
  def show
    
   if params[:group_id]
     Mobject.find(params[:group_id]).madvisors.each do |m|
       ma = Madvisor.where('mobject_id=? and user_id=? and role=?', @mobject.id, m.user_id, "projekte").first
       if !ma
         @ma = Madvisor.new
         @ma.mobject_id = @mobject.id
         @ma.user_id = m.user_id
         @ma.role = "projekte"
         @ma.grade = "Projektmitarbeiter"
         @ma.rate = User.find(m.user_id).rate if User.find(m.user_id).rate
         @ma.save
       end 
     end
   end

    if !params[:topic]
      @topic = "objekte_info"
    else
      @topic = params[:topic]
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

    if @topic == "objekte_ressourcenplanunggruppe" or @topic == "objekte_ressourcenplanung"
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
      
      if @topic == "objekte_details"

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
    
  end

  # GET /mobjects/new
  def new
    @mobject = Mobject.new
    @mobject.status = "OK"
    @mobject.mtype = params[:mtype]
    @mobject.mcategory_id = params[:msubtype]
    @mobject.freecat1 = ""
    @mobject.freecat2 = ""
    @mobject.freecat3 = ""
    @mobject.active = true
    @mobject.online_pub = false
    @mobject.name = ""
    @mobject.description = ""
    @mobject.homepage = ""
    @mobject.costinfo = ""
    @mobject.orderinfo = ""
    @mobject.date_from = Date.today
    @mobject.date_to = Date.today+30
    @mobject.sum_pkosten_ist = 0
    @mobject.sum_pkosten_plan = 100000
    @mobject.sum_paufwand_ist = 0
    @mobject.sum_paufwand_plan = 100
    @mobject.termin = "tief"
    @mobject.kosten = "tief"
    @mobject.qualitaet = "tief"
    @mobject.gesamtstatus = "OK"
    @mobject.allow = false
    @mobject.allowdays = 5
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
  end

  # GET /mobjects/1/edit
  def edit
  end

  # POST /mobjects
  def create
    @mobject = Mobject.new(mobject_params)
    if @mobject.save
      #copy Berechtigungen
      if @mobject.parent > 0
        @parent = Mobject.find(@mobject.parent)
        @parent.madvisors.where('role=?',"projekte").each do |pa|
          @m = Madvisor.new
          @m.mobject_id = @mobject.id
          @m.user_id = pa.user_id
          @m.role = "projekte"
          @m.grade = pa.grade
          @m.save
        end
      end
      if @mobject.owner_type == "User"
        redirect_to user_path(:id => @mobject.owner_id, :topic => "personen_"+@mobject.mtype), notice: (I18n.t :act_create)
      else
        redirect_to company_path(:id => @mobject.owner_id, :topic => "institutionen_"+@mobject.mtype), notice: (I18n.t :act_create)
      end
    else
      render :new
    end
  end

  # PUT /mobjects/1
  def update
    if @mobject.update(mobject_params)
      if @mobject.owner_type == "User"
        redirect_to user_path(:id => @mobject.owner_id, :topic => "personen_"+@mobject.mtype), notice: (I18n.t :act_update)
      else
        redirect_to company_path(:id => @mobject.owner_id, :topic => "institutionen_"+@mobject.mtype), notice: (I18n.t :act_update)
      end
    else
      render :edit
    end
  end

  # DELETE /mobjects/1
  def destroy
    @ownerid = @mobject.owner_id
    @ownertype = @mobject.owner_type
    @mtype = @mobject.mtype
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
      params.require(:mobject).permit(:freecat1, :freecat2, :freecat3, :sum_paufwand_ist, :sum_pkosten_ist, :sum_paufwand_plan, :sum_pkosten_plan, :termin, :kosten, :qualitaet, :gesamtstatus, :costinfo, :orderinfo, :parent, :online_pub, :owner_id, :owner_type, :mtype, :mcategory_id, :company_id, :user_id, :status, :name, :description, :date_from, :date_to, :active, :keywords, :homepage, :address1, :address2, :address3, :allow, :allowdays)
    end

end