require "test_helper"

class SensationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sensations_index_url
    assert_response :success
  end

  test "should get new" do
    get sensations_new_url
    assert_response :success
  end

  test "should get create" do
    get sensations_create_url
    assert_response :success
  end
end
