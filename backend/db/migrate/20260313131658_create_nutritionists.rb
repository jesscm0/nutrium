class CreateNutritionists < ActiveRecord::Migration[7.2]
  def change
    create_table :nutritionists do |t| 
      t.string :first_name, limit: 30, null: false
      t.string :last_name, limit: 30, null: false
      t.string :email, limit: 100, null: false
      t.string :professional_id, limit: 20, null: false
      t.string :created_by, null: false, default: 'SYSTEM'
      t.string :updated_by
      t.timestamps
    end
    add_index :nutritionists, :email, unique: true
    add_index :nutritionists, :professional_id, unique: true
    add_index :nutritionists, [:first_name, :last_name]
  end
end
