class AddindDateToUserEvent < ActiveRecord::Migration
  def change
  	add_column :users_events, :created_at, :datetime
  	add_column :users_events, :updated_at, :datetime
  end
end
