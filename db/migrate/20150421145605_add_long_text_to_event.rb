class AddLongTextToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :long_text, :text
  end
end
