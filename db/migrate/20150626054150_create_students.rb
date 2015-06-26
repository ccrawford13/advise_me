class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :year
      t.string :major

      t.timestamps null: false
    end
    add_foreign_key :students, :users
    add_index :students, :last_name
    add_index :students, :email
    add_index :students, :year
    add_index :students, :major
  end
end
