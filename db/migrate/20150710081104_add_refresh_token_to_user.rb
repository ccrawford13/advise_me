class AddRefreshTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :refresh_token, :string
    add_column :users, :token_expiration, :string
  end
end
