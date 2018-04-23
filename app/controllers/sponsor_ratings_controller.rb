class SponsorRatingsController < ApplicationController
  before_action :set_sponsor_rating, only: [:show, :edit, :update, :destroy]

  # GET /sponsor_ratings
  # GET /sponsor_ratings.json
  def index
    @sponsor_ratings = SponsorRating.all
  end

  # GET /sponsor_ratings/1
  # GET /sponsor_ratings/1.json
  def show
  end

  # GET /sponsor_ratings/new
  def new
    @sponsor_rating = SponsorRating.new
  end

  # GET /sponsor_ratings/1/edit
  def edit
  end

  # POST /sponsor_ratings
  # POST /sponsor_ratings.json
  def create
    @sponsor_rating = SponsorRating.new(sponsor_rating_params)

    respond_to do |format|
      if @sponsor_rating.save
        format.html { redirect_to @sponsor_rating, notice: 'Sponsor rating was successfully created.' }
        format.json { render :show, status: :created, location: @sponsor_rating }
      else
        format.html { render :new }
        format.json { render json: @sponsor_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sponsor_ratings/1
  # PATCH/PUT /sponsor_ratings/1.json
  def update
    respond_to do |format|
      if @sponsor_rating.update(sponsor_rating_params)
        format.html { redirect_to mobject_path(:id => @sponsor_rating.mobject_id, :topic => "objekte_projektberechtigungen"), notice: 'Sponsor rating was successfully updated.' }
        format.json { render :show, status: :ok, location: @sponsor_rating }
      else
        format.html { render :edit }
        format.json { render json: @sponsor_rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sponsor_ratings/1
  # DELETE /sponsor_ratings/1.json
  def destroy
    @sponsor_rating.destroy
    respond_to do |format|
      format.html { redirect_to sponsor_ratings_url, notice: 'Sponsor rating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sponsor_rating
      @sponsor_rating = SponsorRating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sponsor_rating_params
      params.require(:sponsor_rating).permit(:user_id, :mobject_id, :descriptions, :amount, :decision)
    end
end
