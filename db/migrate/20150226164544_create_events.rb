class CreateEvents < ActiveRecord::Migration
  def change
  	 create_table :events do |t|
            t.string :title
            t.string :short_text
            t.datetime :begin
            t.datetime :end
            t.datetime :created_at
            t.datetime :updated_at
     end
  end
end
