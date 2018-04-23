require 'test_helper'

class CompanyParamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_param = company_params(:one)
  end

  test "should get index" do
    get company_params_url
    assert_response :success
  end

  test "should get new" do
    get new_company_param_url
    assert_response :success
  end

  test "should create company_param" do
    assert_difference('CompanyParam.count') do
      post company_params_url, params: { company_param: { color1: @company_param.color1, company_id: @company_param.company_id, role_sponsoring_res: @company_param.role_sponsoring_res, sponsoring_init: @company_param.sponsoring_init, sponsoring_werte1: @company_param.sponsoring_werte1, sponsoring_werte2: @company_param.sponsoring_werte2, sponsoring_werte3: @company_param.sponsoring_werte3, sponsoring_werte4: @company_param.sponsoring_werte4 } }
    end

    assert_redirected_to company_param_url(CompanyParam.last)
  end

  test "should show company_param" do
    get company_param_url(@company_param)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_param_url(@company_param)
    assert_response :success
  end

  test "should update company_param" do
    patch company_param_url(@company_param), params: { company_param: { color1: @company_param.color1, company_id: @company_param.company_id, role_sponsoring_res: @company_param.role_sponsoring_res, sponsoring_init: @company_param.sponsoring_init, sponsoring_werte1: @company_param.sponsoring_werte1, sponsoring_werte2: @company_param.sponsoring_werte2, sponsoring_werte3: @company_param.sponsoring_werte3, sponsoring_werte4: @company_param.sponsoring_werte4 } }
    assert_redirected_to company_param_url(@company_param)
  end

  test "should destroy company_param" do
    assert_difference('CompanyParam.count', -1) do
      delete company_param_url(@company_param)
    end

    assert_redirected_to company_params_url
  end
end
