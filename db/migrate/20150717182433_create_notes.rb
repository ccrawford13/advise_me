class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :student, index: true
      t.string :title
      t.text :body
      t.datetime :date
      t.timestamps null: false
    end
    add_foreign_key :notes, :students
    add_index :notes, :date
  end
end
