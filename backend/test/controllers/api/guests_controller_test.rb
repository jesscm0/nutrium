require "test_helper"

class Api::GuestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    # route helper for index under API namespace
    get api_guests_url
    assert_response :success
  end
end
