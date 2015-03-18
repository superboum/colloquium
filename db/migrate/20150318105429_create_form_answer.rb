class CreateFormAnswer < ActiveRecord::Migration
  def change
  	create_table :form_answers do |t|
  		t.string :answer 
  		t.belongs_to :form_elements,  index: true
  	end 

  	create_table :users_fanswers, id: false do |t|
      t.belongs_to :form_answers, index: true
      t.belongs_to :users, index: true
    end


  end

end
