class WebmastersController < ApplicationController
  before_action :set_webmaster, only: [:show, :edit, :update, :destroy]

  # GET /webmasters
  def index
    @webmasters = Webmaster.all.order(created_at: :desc).page(params[:page]).per_page(10)
    @webanz = @webmasters.count
  end

  # GET /webmasters/1
  def show
  end

  # GET /webmasters/new
  def new
    @webmaster = Webmaster.new
    @webmaster.object_name = params[:object_name]
    @webmaster.object_id = params[:object_id]
    @webmaster.user_id = params[:user_id]
    @webmaster.status = "CHECK"
  end

  # GET /webmasters/1/edit
  def edit
    @webmaster.web_user_id = current_user.id
    @webmaster_edit = true
  end

  # POST /webmasters
  def create
    @webmaster = Webmaster.new(webmaster_params)
    @webmaster.status = "CHECK"
    if @webmaster.save
      item = Object.const_get(@webmaster.object_name).find(@webmaster.object_id)
      redirect_to item, :topic => "objekte_info", notice: (I18n.t :act_create)
      # webmasters_path, notice: 'Webmaster was successfully created.'
    else
      render :new
    end
  end

  # PUT /webmasters/1
  def update
    case params[:commit]
      when "Speichern"
        @webmaster.status = "CHECK"
      when "Freigeben"
        @webmaster.status = "OK"
        item = Object.const_get(@webmaster.object_name).find(@webmaster.object_id)
        if item
          item.active = true
          item.status = "OK"
          item.save
        end
      when "Sperren"
        @webmaster.status = "NOK"
        item = Object.const_get(@webmaster.object_name).find(@webmaster.object_id)
        if item
          item.active = false
          item.status = "NOK"
          item.save
        end
    end 
    if @webmaster.update(webmaster_params)
      redirect_to webmasters_path, notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /webmasters/1
  def destroy
    @webmaster.destroy
    redirect_to webmasters_path, notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_webmaster
      @webmaster = Webmaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def webmaster_params
      params.require(:webmaster).permit(:object_name, :object_id, :user_id, :web_user_id, :user_comment, :web_user_comment, :status)
    end

end
