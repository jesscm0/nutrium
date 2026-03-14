require "test_helper"

class Api::V1::NutritionistsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_nutritionists_index_url
    assert_response :success
  end
end
