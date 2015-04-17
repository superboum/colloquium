class RemoveUserFormAnswer < ActiveRecord::Migration
  def change
  	drop_table :users_form_answers
  	add_belongs_to(:form_answers,:participant,references: :users, index: true)
  end
end
