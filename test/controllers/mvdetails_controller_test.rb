require 'test_helper'

class MvdetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mvdetail = mvdetails(:one)
  end

  test "should get index" do
    get mvdetails_url
    assert_response :success
  end

  test "should get new" do
    get new_mvdetail_url
    assert_response :success
  end

  test "should create mvdetail" do
    assert_difference('Mvdetail.count') do
      post mvdetails_url, params: { mvdetail: { description: @mvdetail.description, mobject_id: @mvdetail.mobject_id, name: @mvdetail.name, sequence: @mvdetail.sequence, video_content_type: @mvdetail.video_content_type, video_file_name: @mvdetail.video_file_name, video_file_size: @mvdetail.video_file_size, video_updated_at: @mvdetail.video_updated_at } }
    end

    assert_redirected_to mvdetail_url(Mvdetail.last)
  end

  test "should show mvdetail" do
    get mvdetail_url(@mvdetail)
    assert_response :success
  end

  test "should get edit" do
    get edit_mvdetail_url(@mvdetail)
    assert_response :success
  end

  test "should update mvdetail" do
    patch mvdetail_url(@mvdetail), params: { mvdetail: { description: @mvdetail.description, mobject_id: @mvdetail.mobject_id, name: @mvdetail.name, sequence: @mvdetail.sequence, video_content_type: @mvdetail.video_content_type, video_file_name: @mvdetail.video_file_name, video_file_size: @mvdetail.video_file_size, video_updated_at: @mvdetail.video_updated_at } }
    assert_redirected_to mvdetail_url(@mvdetail)
  end

  test "should destroy mvdetail" do
    assert_difference('Mvdetail.count', -1) do
      delete mvdetail_url(@mvdetail)
    end

    assert_redirected_to mvdetails_url
  end
end
