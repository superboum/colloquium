class AddindDateToFormAnswer < ActiveRecord::Migration
  def change
  	add_column :form_answers, :created_at, :datetime
  	add_column :form_answers, :updated_at, :datetime	
  end
end
