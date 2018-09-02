class MadvisorsController < ApplicationController
  before_action :set_madvisor, only: [:show, :edit, :update, :destroy]

  # GET /madvisors
  def index
    if params[:search]
      session[:search] = params[:search]
    end
    if params[:mobject_id]
      session[:mobject_id] = params[:mobject_id]
      @mobject = Mobject.find(params[:mobject_id])
    end
    if params[:page]
      session[:page] = params[:page]
    end
    
    if params[:maccess_id]
      @madvisor = Madvisor.where('mobject_id=? and user_id=?', session[:mobject_id], params[:maccess_id]).first
      if !@madvisor
        @madvisor = Madvisor.new
        @madvisor.user_id = params[:maccess_id]
        @madvisor.mobject_id = session[:mobject_id]
        @madvisor.role = @mobject.mtype
        @madvisor.grade = "berechtigt"
      end
      @madvisor.save

      UserMailer.user_access_info(User.find(@madvisor.user_id), "MYproject Information", "Berechtigung erteilt! - Standardberechtigung", @madvisor.mobject).deliver_now

    end
    if params[:madvisor_id]
      @madvisor = Madvisor.where('mobject_id=? and user_id=?', session[:mobject_id], params[:madvisor_id]).first
      if !@madvisor
        @madvisor = Madvisor.new
        @madvisor.user_id = params[:madvisor_id]
        @madvisor.mobject_id = session[:mobject_id]
        @madvisor.role = @mobject.mtype
        case @mobject.mtype
          when "projekte"
            @madvisor.grade = "Projektmitarbeiter"
            @madvisor.rate = User.find(@madvisor.user_id).rate
          when "angebote"
            @madvisor.grade = "Berater"
          when "sponsorantraege"
            @madvisor.grade = "Bewerter"
          when "gruppen"
            @madvisor.grade = "Mitglied"
          when "innovationswettbewerbe"
            @madvisor.grade = "Jury-Mitglied"
        end
      end
      @madvisor.save
      
      UserMailer.user_access_info(User.find(@madvisor.user_id), "myProject Information", "Berechtigung erteilt! - " + @madvisor.grade, @madvisor.mobject).deliver_now

    end
    if params[:senior_madvisor_id]
      @madvisor = Madvisor.where('mobject_id=? and user_id=?', session[:mobject_id], params[:senior_madvisor_id]).first
      if !@madvisor
        @madvisor = Madvisor.new
        @madvisor.user_id = params[:senior_madvisor_id]
        @madvisor.mobject_id = session[:mobject_id]
        @madvisor.role = @mobject.mtype
        case @mobject.mtype
          when "projekte"
            @madvisor.grade = "Projektleiter"
            @madvisor.rate = User.find(@madvisor.user_id).rate
          when "angebote"
            @madvisor.grade = "Senior Berater"
          when "sponsorantraege"
            @madvisor.grade = "Entscheider"
          when "gruppen"
            @madvisor.grade = "Gruppenlead"
          when "innovationswettbewerbe"
            @madvisor.grade = "Jury-Vorsitz"
        end
      end
      @madvisor.save

      UserMailer.user_access_info(User.find(@madvisor.user_id), "myProject Information", "Berechtigung erteilt! - " + @madvisor.grade, @madvisor.mobject).deliver_now

    end
    if params[:delete_madvisor_id]
      @madvisor = Madvisor.where('mobject_id=? and user_id=?', session[:mobject_id], params[:delete_madvisor_id]).first
      if @madvisor
        @madvisor.destroy

        UserMailer.user_access_info(User.find(@madvisor.user_id), "myProject Information", "Berechtigung gelöscht! - " + @madvisor.grade, @madvisor.mobject).deliver_now

      end
    end

    @users = User.search(false, session[:search]).page(params[:page]).per_page(10)
    @madvisors = Madvisor.where('mobject_id=?', session[:mobject_id])
    @mobject = Mobject.find(session[:mobject_id])
    @array=[]
    @madvisors.each do |ad|
      hash = Hash.new
      hash = {"key" => ad.user_id, "grade" => ad.grade}
      @array << hash
    end

  end

  # GET /madvisors/1
  def show
  end

  # GET /madvisors/new
  def new
    @madvisor = Madvisor.new
    
    @madvisor.mobject_id = params[:mobject_id]
    @madvisor.role = Mobject.find(params[:mobject_id]).mtype
    @madvisor.user_id = params[:user_id]
    if User.find(params[:user_id]).rate
      @madvisor.rate = User.find(params[:user_id]).rate
    else
      @madvisor.rate = 0
    end
    case @madvisor.role
      when "projekte"
        @madvisor.grade = "Projektmitarbeiter"
      when "gruppen"
        @madvisor.grade = "Gruppenmitglied"
      end
  end

  # GET /madvisors/1/edit
  def edit
  end

  # POST /madvisors
  def create
    @madvisor = Madvisor.new(madvisor_params)
    if @madvisor.save
      case @madvisor.mobject.mtype
        when "projekte"
          @topic = "objekte_projektberechtigungen"
          @text = "Berechtigung erteilt! "
        when "gruppen"
          @topic = "objekte_gruppenmitglieder"
          @text = "Mitteilung! "
      end
      UserMailer.user_access_info(User.find(@madvisor.user_id), "myPROJECT Information", @text + @madvisor.grade, @madvisor.mobject).deliver_now
      redirect_to mobject_path(:id => @madvisor.mobject_id, :topic => @topic), notice: (I18n.t :act_create)
    else
      render :new
    end
  end

  # PUT /madvisors/1
  def update
    if @madvisor.update(madvisor_params)
      case @madvisor.mobject.mtype
        when "projekte"
          @topic = "objekte_projektberechtigungen"
        when "gruppen"
          @topic = "objekte_gruppenmitglieder"
      end
      UserMailer.user_access_info(User.find(@madvisor.user_id), "myPROJECT Information", "Berechtigung geändert! - " + @madvisor.grade, @madvisor.mobject).deliver_now
      redirect_to(mobject_path(:id => @madvisor.mobject_id, :topic => @topic), notice: (I18n.t :act_update))
    else
      render :edit
    end
  end

  # DELETE /madvisors/1
  def destroy
    @id = @madvisor.mobject_id
    case @madvisor.mobject.mtype
      when "projekte"
        @topic = "objekte_projektberechtigungen"
      when "gruppen"
        @topic = "objekte_gruppenmitglieder"
    end
    @madvisor.destroy
    #UserMailer.user_access_info(User.find(@madvisor.user_id), "myPROJECT Information", "Berechtigung erteilt! - " + @madvisor.grade, @madvisor.mobject).deliver_now
    redirect_to(mobject_path(:id => @id, :topic => @topic), notice: (I18n.t :act_delete))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_madvisor
      @madvisor = Madvisor.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def madvisor_params
      params.require(:madvisor).permit(:mobject_id, :user_id, :grade, :role, :rate)
    end
    
    
end
