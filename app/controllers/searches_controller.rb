class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]

  # GET /searches
  def index
    if params[:search_domain]
      @search_domain = params[:search_domain]
    end
    if params[:controller_name]
      @controller_name = params[:controller_name]
    end
    if params[:mtype]
      @mtype = params[:mtype]
    end
    if @mtype
      @searches = Search.where('search_domain=? and user_id=? and mtype=?', params[:search_domain], current_user.id, @mtype).page(params[:page]).per_page(10)
    else
      @searches = Search.where('search_domain=? and user_id=?', params[:search_domain], current_user.id).page(params[:page]).per_page(10)
    end
    @seranz = @searches.count
  end

  # GET /searches/1
  def show
  end

  # GET /searches/new
  def new
    @search = Search.new
    @search.name = ""
    @search.sql_string = []
    @search.search_domain = params[:search_domain]
    @search.mtype = params[:mtype]
    @search.user_id = params[:user_id]
    @search.controller = params[:controller_name]
    @search.date_from = Date.today
    @search.date_to = Date.today + 30
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  def create
    @search = Search.new(search_params)
    if @search.save
        @search.build_sql(current_user)
        case @search.controller
          when "companies"
            redirect_to companies_path(:filter_id => @search.id), notice: (I18n.t :act_create)
          when "users"
            redirect_to users_path(:filter_id => @search.id), notice: (I18n.t :act_create)
         when "mobjects"
            redirect_to mobjects_path(:filter_id => @search.id), notice: (I18n.t :act_create)
        end
        #redirect_to searches_path(:user_id => current_user.id, :search_domain => @search.search_domain, :mtype => @search.mtype, :msubtype => @search.msubtype, :controller_name => @search.controller, :ticket_id => @search.ticket_id), notice: (I18n.t :act_create)
    else
      render :new
    end
  end

  # PUT /searches/1
  def update
    if @search.update(search_params)
        case @search.controller
          when "companies"
            redirect_to companies_path(:filter_id => @search.id), notice: (I18n.t :act_update)
          when "users"
            redirect_to users_path(:filter_id => @search.id), notice: (I18n.t :act_update)
         when "mobjects"
            redirect_to mobjects_path(:filter_id => @search.id), notice: (I18n.t :act_update)
        end
        #redirect_to searches_path(:user_id => current_user.id, :search_domain => @search.search_domain, :mtype => @search.mtype, :msubtype => @search.msubtype, :controller_name => @search.controller), notice: (I18n.t :act_update)
    else
      render :edit
    end
  end

  # DELETE /searches/1
  def destroy
    @search.destroy
    case @search.controller
        when "companies"
          redirect_to companies_path(:filter_id => nil), notice: (I18n.t :act_delete)
        when "users"
          redirect_to users_path(:filter_id => nil), notice: (I18n.t :act_delete)
        when "mobjects"
          redirect_to users_path(:filter_id => nil), notice: (I18n.t :act_delete)
      end
    #redirect_to searches_path(:user_id => current_user.id, :search_domain => @save_search_domain, :controller_name => @save_search_controller, :mtype => @save_search_mtype), notice: (I18n.t :act_delete)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
      #@search.build_sql
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:counter, :mtype, :date_from, :date_to, :search_domain, :controller, :user_id, :name, :description, :status, :mcategory_id, :keywords, :date_created_at)
    end
end
