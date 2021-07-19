require "test_helper"

class Api::V1::CheckDomainsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_check_domains_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_check_domains_create_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_check_domains_show_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_check_domains_destroy_url
    assert_response :success
  end
end
