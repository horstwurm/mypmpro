class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @comment.user_id = params[:user_id]
    @comment.mobject_id = params[:mobject_id]
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        if @comment.mobject.mtype == "artikel"
          @topic = "objekte_info"
        else
          @topic = "objekte_blog"
        end
        format.html { redirect_to mobject_path(:id => @comment.mobject_id, :topic => @topic, :edition_id => session[:edition_id]), notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        if @mrating.mobject.mtype == "artikel"
          @topic = "objekte_info"
        else
          @topic = "objekte_blog"
        end
        format.html { redirect_to mobject_path(:id => @comment.mobject_id, :topic => @topic, :edition_id => session[:edition_id]), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @mobject_id = @comment.mobject_id
    if @mrating.mobject.mtype == "artikel"
      @topic = "objekte_info"
    else
      @topic = "objekte_blog"
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to mobject_path(:id => @mobject_id, :topic => @topic, :edition_id => session[:edition_id]), notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :mobject_id, :description)
    end
end
