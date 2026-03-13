class CreateDistricts < ActiveRecord::Migration[7.2]
  def change
    create_table :districts do |t|
      t.string :name, limit: 50, null: false
      t.string :code, limit: 50, null: false
      t.string :language, limit: 2, null: false, default: 'pt'
      t.string :created_by, null: false, default: 'SYSTEM'
      t.string :updated_by
      t.timestamps
    end
    add_index :districts, :code, unique: true
  end
end