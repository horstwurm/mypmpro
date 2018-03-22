class PublicationArticlesController < ApplicationController
  before_action :set_publication_article, only: [:show, :edit, :update, :destroy]

  # GET /publication_articles
  # GET /publication_articles.json
  def index
    @publication_articles = PublicationArticle.all
  end

  # GET /publication_articles/1
  # GET /publication_articles/1.json
  def show
  end

  # GET /publication_articles/new
  def new
    if session[:publication] and params[:article]
      @publication_article = PublicationArticle.new
      @publication_article.publication = session[:publication]
      @publication_article.article = params[:article]
      @publication_article.active = true
      @publication_article.status = "active"
      @publication_article.sequence = PublicationArticle.where('publication=?',session[:publication]).count+1
      @publication_article.save
      session[:publication]=nil
      redirect_to mobject_path(:id => @publication_article.publication, :topic => "objekte_artikel"), notice: 'Publication article was successfully created.'
    end
  end

  # GET /publication_articles/1/edit
  def edit
  end

  # POST /publication_articles
  # POST /publication_articles.json
  def create
    @publication_article = PublicationArticle.new(publication_article_params)

    respond_to do |format|
      if @publication_article.save
        format.html { redirect_to mobject_path(:id => @publication_article.publication, :topic => "objekte_"), notice: 'Publication article was successfully created.' }
        format.json { render :show, status: :created, location: @publication_article }
      else
        format.html { render :new }
        format.json { render json: @publication_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publication_articles/1
  # PATCH/PUT /publication_articles/1.json
  def update
    respond_to do |format|
      if @publication_article.update(publication_article_params)
        format.html { redirect_to @publication_article, notice: 'Publication article was successfully updated.' }
        format.json { render :show, status: :ok, location: @publication_article }
      else
        format.html { render :edit }
        format.json { render json: @publication_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publication_articles/1
  # DELETE /publication_articles/1.json
  def destroy
    @publication_article_publication = @publication_article.publication 
    @publication_article.destroy
    respond_to do |format|
      format.html { redirect_to mobject_path(:id => @publication_article_publication, :topic => "objekte_artikel"),  notice: 'Publication article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_publication_article
      @publication_article = PublicationArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publication_article_params
      params.require(:publication_article).permit(:publication, :article, :status, :active, :sequence)
    end
end
