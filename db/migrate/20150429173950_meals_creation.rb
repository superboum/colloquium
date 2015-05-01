class MealsCreation < ActiveRecord::Migration
  def change
  	create_table :meals do |t|
  		t.date :day 
  		t.integer :meal
  	end 

  	create_table :users_meals, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :meal, index: true
    end


  end
end
