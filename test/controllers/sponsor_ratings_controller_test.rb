require 'test_helper'

class SponsorRatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sponsor_rating = sponsor_ratings(:one)
  end

  test "should get index" do
    get sponsor_ratings_url
    assert_response :success
  end

  test "should get new" do
    get new_sponsor_rating_url
    assert_response :success
  end

  test "should create sponsor_rating" do
    assert_difference('SponsorRating.count') do
      post sponsor_ratings_url, params: { sponsor_rating: { amount: @sponsor_rating.amount, decision: @sponsor_rating.decision, descriptions: @sponsor_rating.descriptions, mobject_id: @sponsor_rating.mobject_id, user_id: @sponsor_rating.user_id } }
    end

    assert_redirected_to sponsor_rating_url(SponsorRating.last)
  end

  test "should show sponsor_rating" do
    get sponsor_rating_url(@sponsor_rating)
    assert_response :success
  end

  test "should get edit" do
    get edit_sponsor_rating_url(@sponsor_rating)
    assert_response :success
  end

  test "should update sponsor_rating" do
    patch sponsor_rating_url(@sponsor_rating), params: { sponsor_rating: { amount: @sponsor_rating.amount, decision: @sponsor_rating.decision, descriptions: @sponsor_rating.descriptions, mobject_id: @sponsor_rating.mobject_id, user_id: @sponsor_rating.user_id } }
    assert_redirected_to sponsor_rating_url(@sponsor_rating)
  end

  test "should destroy sponsor_rating" do
    assert_difference('SponsorRating.count', -1) do
      delete sponsor_rating_url(@sponsor_rating)
    end

    assert_redirected_to sponsor_ratings_url
  end
end
