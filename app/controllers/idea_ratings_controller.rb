class IdeaRatingsController < ApplicationController
  before_action :set_idea_rating, only: [:show, :edit, :update, :destroy]

  # GET /idea_ratings
  # GET /idea_ratings.json
  def index
    @idea = Idea.find(params[:idea_id])
    #@idea_ratings = IdeaRating.all
  end

  # GET /idea_ratings/1
  # GET /idea_ratings/1.json
  def show
  end

  # GET /idea_ratings/new
  def new
    @idea_rating = IdeaRating.new
  end

  # GET /idea_ratings/1/edit
  def edit
  end

  # POST /idea_ratings
  # POST /idea_ratings.json
  def create
    @idea_rating = IdeaRating.new(idea_rating_params)

    respond_to do |format|
      if @idea_rating.save
        format.html { redirect_to @idea_rating, notice: (I18n.t :act_create) }
        format.json { render :show, status: :created, location: @idea_rating }
      else
        format.html { render :new }
        format.json { render json: @idea_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /idea_ratings/1
  # PATCH/PUT /idea_ratings/1.json
  def update
    respond_to do |format|
      if @idea_rating.update(idea_rating_params)
        format.html { redirect_to idea_ratings_path(:idea_id => @idea_rating.idea_id), notice: (I18n.t :act_update) }
        format.json { render :show, status: :ok, location: @idea_rating }
        calc_idea_rating
      else
        format.html { render :edit }
        format.json { render json: @idea_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /idea_ratings/1
  # DELETE /idea_ratings/1.json
  def destroy
    @idea_rating.destroy
    respond_to do |format|
      format.html { redirect_to idea_ratings_url, notice: (I18n.t :act_delete) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_idea_rating
      @idea_rating = IdeaRating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def idea_rating_params
      params.require(:idea_rating).permit(:idea_id, :crit_id, :user_id, :rating, :rating_text)
    end
    
    def calc_idea_rating
      sum = 0
      anz = @idea_rating.idea.idea_ratings.count
      @idea_rating.idea.idea_ratings.each do |ir|
        if ir.crit and ir.crit.rating and ir.rating
          sum = sum + (ir.crit.rating*ir.rating/100)
        end
      end
      if sum > 0
        @idea = Idea.find(@idea_rating.idea)
        if @idea
          @idea.rating = sum/anz
          @idea.save
        end
      end
    end
    
end
