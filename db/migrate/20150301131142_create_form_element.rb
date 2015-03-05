class CreateFormElement < ActiveRecord::Migration
	def change
		create_table :form_elements do |t|
			t.string :question
			t.integer :type
			t.text :data
      t.belongs_to :event,  index: true
		end
	end
end
