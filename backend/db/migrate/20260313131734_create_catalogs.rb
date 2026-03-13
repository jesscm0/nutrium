class CreateCatalogs < ActiveRecord::Migration[7.2]
  def change
    create_table :catalogs do |t|
      t.references :nutritionist, null: false, foreign_key: { to_table: "nutritionists" }
      t.references :service, null: false, foreign_key: { to_table: "services" }
      t.references :district, foreign_key: { to_table: "districts" }
      t.decimal :price, precision: 5, scale: 2, null: false
      t.string :address, limit: 300, null: true
      t.integer :duration, null: false
      t.string :created_by, null: false, default: 'SYSTEM'
      t.string :updated_by
      t.timestamps
    end
    add_index :catalogs, [:nutritionist_id, :service_id, :district_id], unique: true
  end
end
