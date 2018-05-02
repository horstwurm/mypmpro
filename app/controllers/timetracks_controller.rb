class TimetracksController < ApplicationController
  before_action :set_timetrack, only: [:show, :edit, :update, :destroy]
  after_action :update_mobject,  only: [:edit, :create, :update, :destroy]

  # GET /timetracks
  # GET /timetracks.json
  def index
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
      @c_mode = "Monat"
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
    if params[:user_id]
      @user = User.find(params[:user_id])
      @timetracks = Timetrack.select("mobject_id").where('user_id=?', @user.id).distinct
    end
    if params[:mobject_id]
      @mobject = Mobject.find(params[:mobject_id])
      if @c_mode == "alles"
        @timetracks = Timetrack.select("user_id").where('mobject_id=?', @mobject.id).distinct
      else
        @timetracks = Timetrack.select("user_id").where('mobject_id=? and datum >=? and datum <=?', @mobject.id, @date_start, @date_end).distinct
      end  
    end

  end
  

  # GET /timetracks/1
  # GET /timetracks/1.json
  def show
  end

  # GET /timetracks/new
  def new
    @timetrack = Timetrack.new
    if params[:mobject_id]
      @timetrack.mobject_id = params[:mobject_id]
    else
      @advisors = current_user.madvisors.where('role=?',"projekte")
      if @advisors.first
        @timetrack.mobject_id = @advisors.first.mobject_id
        @mobs = []
        @mobsID = []
        @advisors.each do |m|
          if Mobject.find(m.mobject_id).active
            @mobs << [m.mobject.name, m.mobject_id]
            @mobsID << m.mobject_id
          end
        end
        
        @mobs = []
        @mobjects = Mobject.where('id IN (?)', @mobsID).order(:name)
        @mobjects.each do |m|
          @mobs << [m.name, m.id]
        end
        
      else
        redirect_to user_path(:id => params[:user_id], :topic => "personen_zeiterfassung"), notice: (I18n.t :noprojects)
      end
    end
    if params[:user_id]
      @timetrack.user_id = params[:user_id]
    end
    if params[:scope]
      @timetrack.costortime = params[:scope]
    else
      @timetrack.costortime = "aufwand"
    end
    if params[:datum]
      @timetrack.datum=params[:datum]
    else
      @timetrack.datum=Date.today.strftime('%Y-%m-%d')
    end
    if @timetrack.costortime == "aufwand"
      @timetrack.amount = 8.0
      @timetrack.activity = "Aktivität..."
    end
    if @timetrack.costortime == "kosten"
      @timetrack.amount = 25000.00
      @timetrack.activity = "Kosten..."
    end
  end

  # GET /timetracks/1/edit
  def edit
  end

  # POST /timetracks
  # POST /timetracks.json
  def create
    
    @timetrack = Timetrack.new(timetrack_params)
    if !@timetrack.mobject.allow
      @mobject = @timetrack.mobject
      @mobject.allow = false
      @mobject.allowdays = 3
      @mobject.save
    end

    respond_to do |format|
      if (@timetrack.datum <= Date.today-@timetrack.mobject.allowdays and @timetrack.datum.strftime("%m") != Date.today.strftime("%m")) or @timetrack.mobject.allow == false
        format.html { redirect_to new_timetrack_path(:user_id => @timetrack.user_id, :mobject_id => @timetrack.mobject_id, :scope => @timetrack.costortime, :tdatum => @timetrack.datum), notice: "Keine Zeiterfassung mehr möglich!" }
      end
      if @timetrack.save
        #format.html { redirect_to timetracks_path(:mobject_id => @timetrack.mobject_id, :scope => @timetrack.costortime), notice: (I18n.t :act_create) }
        format.html { redirect_to user_path(:id => @timetrack.user_id, :topic => "personen_zeiterfassung", :scope => @timetrack.costortime, :tdatum => @timetrack.datum), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @timetrack }
      else
        format.html { render :new }
        format.json { render json: @timetracks.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timetracks/1
  # PATCH/PUT /timetracks/1.json
  def update
    respond_to do |format|
      if @timetrack.update(timetrack_params)
        #format.html { redirect_to timetracks_path(:mobject_id => @timetrack.mobject_id), notice: 'Timetrack was successfully updated.' }
        format.html { redirect_to user_path(:id => @timetrack.user_id, :topic => "personen_zeiterfassung", :scope => @timetrack.costortime, :tdatum => @timetrack.datum), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @timetrack }
      else
        format.html { render :edit }
        format.json { render json: @timetracks.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timetracks/1
  # DELETE /timetracks/1.json
  def destroy
    #@timetrack_mobject_id = @timetrack.mobject_id
    @timetrack_user_id = @timetrack.user_id
    @timetrack_costorid = @timetrack.costortime
    @timetrack_datum = @timetrack.datum
    @timetrack.destroy
    respond_to do |format|
      #format.html { redirect_to timetracks_path(:mobject_id => @timetrack_mobject_id), notice: (I18n.t act_de) }
      format.html { redirect_to user_path(:id => @timetrack_user_id, :topic => "personen_zeiterfassung", :scope => @timetrack_costortime, :tdatum => @timetrack_datum), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timetrack
      @timetrack = Timetrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timetrack_params
      params.require(:timetrack).permit(:costortime, :jahrmonat, :user_id, :mobject_id, :activity, :amount, :datum)
    end
    
    def update_mobject
      @mobject = @timetrack.mobject
      if @timetrack.costortime == "kosten"
        @mobject.sum_pkosten_ist = @mobject.timetracks.where('costortime=?',"kosten").sum(:amount)
      end
      if @timetrack.costortime == "aufwand"
        @mobject.sum_paufwand_ist = @mobject.timetracks.where('costortime=?',"aufwand").sum(:amount)/8
      end 
      @mobject.save
    end
    
end
