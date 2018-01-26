require 'test_helper'

class IotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @iot = iots(:one)
  end

  test "should get index" do
    get iots_url
    assert_response :success
  end

  test "should get new" do
    get new_iot_url
    assert_response :success
  end

  test "should create iot" do
    assert_difference('Iot.count') do
      post iots_url, params: { iot: { name: @iot.name, owner_id: @iot.owner_id, owner_type: @iot.owner_type, value: @iot.value } }
    end

    assert_redirected_to iot_url(Iot.last)
  end

  test "should show iot" do
    get iot_url(@iot)
    assert_response :success
  end

  test "should get edit" do
    get edit_iot_url(@iot)
    assert_response :success
  end

  test "should update iot" do
    patch iot_url(@iot), params: { iot: { name: @iot.name, owner_id: @iot.owner_id, owner_type: @iot.owner_type, value: @iot.value } }
    assert_redirected_to iot_url(@iot)
  end

  test "should destroy iot" do
    assert_difference('Iot.count', -1) do
      delete iot_url(@iot)
    end

    assert_redirected_to iots_url
  end
end
