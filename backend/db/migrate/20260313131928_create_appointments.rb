class CreateAppointments < ActiveRecord::Migration[7.2]
  def change
    create_table :appointments do |t|
      t.references :guest, null: false, foreign_key: { to_table: "guests" }
      t.references :catalog, null: false, foreign_key: { to_table: "catalogs" }
      t.integer :status, null: false, default: 0 #pendent
      t.datetime :scheduled_at, null: false
      t.string :created_by, null: false, default: 'SYSTEM'
      t.string :updated_by
      t.timestamps
    end
    add_index :appointments, :status
    add_index :appointments, :scheduled_at
  end
end
