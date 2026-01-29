require "test_helper"

class RegistrosControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get registros_new_url
    assert_response :success
  end

  test "should get create" do
    get registros_create_url
    assert_response :success
  end
end
