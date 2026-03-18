require "test_helper"

class CatalogTest < ActiveSupport::TestCase
  test "search_by_text should ignore accents" do

    
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
    results = Catalog.search_by_text("silvia")
    assert_includes results, catalog, "Deveria encontrar 'Sílvia' pesquisando por 'silvia'"
    #assert_includes - Ensures the catalog is included on results

    # pg search without ~ or ç 
    results = Catalog.search_by_text("nutricao")
    assert_includes results, catalog, "Deveria encontrar 'Nutrição' pesquisando por 'nutricao'"
 

    #pg search with half word 
    results = Catalog.search_by_text("nutri")
    assert_includes results, catalog, "Deveria encontrar 'Nutrição' pesquisando por 'nutri'"

    # pg search by similarity
    results = Catalog.search_by_text("barga")
    assert_includes results, catalog, "Deveria encontrar 'Braga' pesquisando por 'barga'"
 
  end
end
