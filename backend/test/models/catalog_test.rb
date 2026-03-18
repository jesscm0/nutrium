require "test_helper"

class CatalogTest < ActiveSupport::TestCase
  test "pg search should ignore accents" do

    
    catalog = Catalog.create!(
      nutritionist: Nutritionist.create!(
        first_name: "Sílvia", last_name: "Costa", 
        email: "silvia@email.com", professional_id: "1234N"),
      service: services(:general_initial),
      district: districts(:braga),
      price: 50, 
      duration: 30
    )

    # pg search without í 
    results = Catalog.search_by_profile("silvia")
    assert_includes results, catalog, "Should find 'Sílvia' searching for 'silvia'"
    #assert_includes - Ensures the catalog is included on results

    # pg search without ~ or ç 
    results = Catalog.search_by_profile("nutricao")
    assert_includes results, catalog, "Should find 'Nutrição' searching for 'nutricao'"
 

    #pg search with half word 
    results = Catalog.search_by_profile("nutri")
    assert_includes results, catalog, "Should find 'Nutrição' searching for 'nutri'"

    # pg search by similarity
    results = Catalog.search_by_location("barga")
    assert_includes results, catalog, "Should find 'Braga' searching for 'barga'"
 
  end
end
