require 'test_helper'

class PplansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pplan = pplans(:one)
  end

  test "should get index" do
    get pplans_url
    assert_response :success
  end

  test "should get new" do
    get new_pplan_url
    assert_response :success
  end

  test "should create pplan" do
    assert_difference('Pplan.count') do
      post pplans_url, params: { pplan: { date_from: @pplan.date_from, date_to: @pplan.date_to, mobject_id: @pplan.mobject_id, poc: @pplan.poc, position: @pplan.position, tasktype: @pplan.tasktype, version: @pplan.version, version_name: @pplan.version_name } }
    end

    assert_redirected_to pplan_url(Pplan.last)
  end

  test "should show pplan" do
    get pplan_url(@pplan)
    assert_response :success
  end

  test "should get edit" do
    get edit_pplan_url(@pplan)
    assert_response :success
  end

  test "should update pplan" do
    patch pplan_url(@pplan), params: { pplan: { date_from: @pplan.date_from, date_to: @pplan.date_to, mobject_id: @pplan.mobject_id, poc: @pplan.poc, position: @pplan.position, tasktype: @pplan.tasktype, version: @pplan.version, version_name: @pplan.version_name } }
    assert_redirected_to pplan_url(@pplan)
  end

  test "should destroy pplan" do
    assert_difference('Pplan.count', -1) do
      delete pplan_url(@pplan)
    end

    assert_redirected_to pplans_url
  end
end
