class CreateServices < ActiveRecord::Migration[7.2]
  def change
    create_table :services do |t|
      t.string :code, limit: 30, null: false
      t.string :service_type, limit: 30, null: false
      t.string :description, limit: 100, null: false
      t.string :created_by, null: false, default: 'SYSTEM'
      t.string :updated_by
      t.timestamps
    end
    add_index :services, [:code, :service_type], unique: true
  end
end
