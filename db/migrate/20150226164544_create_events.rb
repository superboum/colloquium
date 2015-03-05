class CreateEvents < ActiveRecord::Migration
  def change
  	 create_table :events do |t|
            t.string :name
            t.string :short_text
            t.datetime :start_date
            t.datetime :end_date
            t.datetime :created_at
            t.datetime :updated_at
            t.boolean :registration
            t.integer :place_number
     end
  end
end
