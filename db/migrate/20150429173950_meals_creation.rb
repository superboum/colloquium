class MealsCreation < ActiveRecord::Migration
  def change
  	create_table :meals do |t|
  		t.datetime :date_of_meal 
  	end 

  	create_table :users_meals, id: false do |t|
      t.belongs_to :users, index: true
      t.belongs_to :meals, index: true
    end


  end
end
