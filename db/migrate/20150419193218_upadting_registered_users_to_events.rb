class UpadtingRegisteredUsersToEvents < ActiveRecord::Migration
  def change
  	rename_table :registered_users_to_events, :users_events
  end
end
