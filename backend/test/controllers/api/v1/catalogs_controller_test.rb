require "test_helper"

class Api::V1::CatalogsControllerTest < ActionDispatch::IntegrationTest

    test "should filter catalogs by location and name ignoring accents and multiple keys" do

        get api_v1_catalogs_url(format: :json), params: { 
            location: "braga", 
            name: "nutricao clinica" 
        }

        assert_response :success

        json_response = JSON.parse(response.body)

        assert_not_empty json_response, "Catalog should be found for [braga nutricao silvia]"

        first_result = json_response.first
        assert_match /Braga/i, first_result["location"]
        assert_match /Nutrição/i, first_result["name"] 
    end



    test "should filter catalogs by location and name with half words and misspelling" do

        get api_v1_catalogs_url(format: :json), params: { 
            location: "barga", 
            name: "nutri" 
        }

        assert_response :success

        json_response = JSON.parse(response.body)

        assert_not_empty json_response, "Catalog should be found for [barga nutri]"

        first_result = json_response.first
        assert_match /Braga/i, first_result["location"]
        assert_match /Nutrição/i, first_result["name"] 
    end

end
