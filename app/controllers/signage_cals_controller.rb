class SignageCalsController < ApplicationController
  before_action :set_signage_cal, only: [:show, :edit, :update, :destroy]

  # GET /signage_cals
  # GET /signage_cals.json
  def index
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
      if params[:loc_id]
        @loc = Mobject.find(params[:loc_id])
        @cals = SignageCal.where('mstandort=?', params[:loc_id])
        session[:signage_cal_mode] = "loc"
      end
      if params[:kam_id]
        @kam = Mobject.find(params[:kam_id])
        @cals = SignageCal.where('mkampagne=?', params[:kam_id])
        session[:signage_cal_mode] = "kam"
      end
      if @cals
        @anz = @cals.count
        @cals.each do |c|
          
          if @kam
            @obj = Mobject.find(c.mstandort)
          end
          if @loc
            @obj = Mobject.find(c.mkampagne)
          end

          info = '<i class="fa fa-calender"></i>'
  
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

  # GET /signage_cals/1
  # GET /signage_cals/1.json
  def show
  end

  # GET /signage_cals/new
  def new
    @signage_cal = SignageCal.new
    @signage_cal.date_from = Date.today
    @signage_cal.date_to = Date.today + 5
    @signage_cal.time_from = 0
    @signage_cal.time_to = 24
    if params[:loc_id]
      @loc = Mobject.find(params[:loc_id])
      @signage_cal.mstandort = @loc.id
    end
    if params[:kam_id]
      @kam = Mobject.find(params[:kam_id])
      @signage_cal.mkampagne = @kam.id
    end
  end

  # GET /signage_cals/1/edit
  def edit
    if session[:signage_cal_mode] == "loc"
      @loc = Mobject.find(@signage_cal.mstandort)
    end
    if session[:signage_cal_mode] == "kam"
      @kam = Mobject.find(@signage_cal.mkampagne)
    end
  end

  # POST /signage_cals
  # POST /signage_cals.json
  def create
    @signage_cal = SignageCal.new(signage_cal_params)
    if @signage_cal.save
      if session[:signage_cal_mode] == "loc"
        redirect_to mobject_path(:id => @signage_cal.mstandort, :topic => "objekte_signcal"), notice: (I18n.t :act_create)
      end
      if session[:signage_cal_mode] == "kam"
        redirect_to mobject_path(:id => @signage_cal.mkampagne, :topic => "objekte_signcal"), notice: (I18n.t :act_create)
      end
    else
      render :new
    end
  end

  # PATCH/PUT /signage_cals/1
  # PATCH/PUT /signage_cals/1.json
  def update
    if @signage_cal.update(signage_cal_params)
      if session[:signage_cal_mode] == "loc"
        redirect_to mobject_path(:id => @signage_cal.mstandort, :topic => "objekte_signcal"), notice: (I18n.t :act_update)
      end
      if session[:signage_cal_mode] == "kam"
        redirect_to mobject_path(:id => @signage_cal.mkampagne, :topic => "objekte_signcal"), notice: (I18n.t :act_update)
      end
    else
      render :edit 
    end
  end

  # DELETE /signage_cals/1
  # DELETE /signage_cals/1.json
  def destroy
    @signage_cal_mstandort = @signage_cal.mstandort
    @signage_cal_mkampagne = @signage_cal.mkampagne
    @signage_cal.destroy
    if session[:signage_cal_mode] == "loc"
      redirect_to mobject_path(:id => @signage_cal_mstandort, :topic => "objekte_signcal"), notice: (I18n.t :act_delete) 
    end
    if session[:signage_cal_mode] == "kam"
      redirect_to mobject_path(:id => @signage_cal_mkampagne, :topic => "objekte_signcal"), notice: (I18n.t :act_delete)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_signage_cal
      @signage_cal = SignageCal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def signage_cal_params
      params.require(:signage_cal).permit(:mkampagne, :mstandort, :confirmed, :date_from, :date_to, :time_from, :time_to)
    end
end
