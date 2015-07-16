class AddFileToStudent < ActiveRecord::Migration
  def change
    add_column :students, :file, :string
  end
end
