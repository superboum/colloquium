class AddTokenInUsers < ActiveRecord::Migration
  def up
    add_column :users, :token, :string, default: nil
  end

  def down
    remove_column :users, :token
  end
end
