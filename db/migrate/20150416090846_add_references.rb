class AddReferences < ActiveRecord::Migration
  def change
  	remove_column :form_answers, :form_elements_id
    add_reference :form_answers, :form_element, references: :form_elements, :index => true
  end
end
