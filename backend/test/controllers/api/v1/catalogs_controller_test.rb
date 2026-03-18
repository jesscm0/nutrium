require "test_helper"

class Api::V1::CatalogsControllerTest < ActionDispatch::IntegrationTest

    test "should filter catalogs by location and name ignoring accents and multiple keys" do
puts "A testar URL: #{api_v1_catalogs_path(format: :json)}"
        get api_v1_catalogs_url(format: :json), params: { 
            location: "braga", 
            name: "nutricao silvia" # Teste sem acentuação e com múltiplos termos
        }

        assert_response :success

        json_response = JSON.parse(response.body)

        puts (json_response.first)

        assert_not_empty json_response, "Deveria encontrar catálogos para o serviço Nutrição da nutricionista Sílvia"

        first_result = json_response.first
        assert_match /Braga/i, first_result["location"]
        assert_match /Nutrição/i, first_result["name"] 
    end

end
