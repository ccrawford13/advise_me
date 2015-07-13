class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.references :user, index: true
      t.string :summary
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :attendees
      t.timestamps null: false
    end
    add_foreign_key :appointments, :users
    add_index :appointments, :attendees
  end
end
