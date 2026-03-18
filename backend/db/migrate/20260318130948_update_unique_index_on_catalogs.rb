class UpdateUniqueIndexOnCatalogs < ActiveRecord::Migration[7.2]
  def change
    remove_index :catalogs, column: [:nutritionist_id, :service_id, :district_id]
    
    add_index :catalogs, 
              [:nutritionist_id, :service_id, :district_id, :address], 
              unique: true, 
              name: 'index_unique_service_location_address'
  end
end