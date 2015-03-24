class AddEventToFormAnswers < ActiveRecord::Migration
  def change
  	add_belongs_to(:form_answers,:event, index: true)
  end
end
