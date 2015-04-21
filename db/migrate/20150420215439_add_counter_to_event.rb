class AddCounterToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :spots_number_limit, :integer, default: 0
  	remove_column :events, :place_number
  	add_column :events, :number_of_participants, :integer, default: 0
  end
end
