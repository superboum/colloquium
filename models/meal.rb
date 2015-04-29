require 'sinatra/activerecord'

class Meal < ActiveRecord::Base
  has_many :users_meals
  has_many :participants, through: :users_meals, source: :user
  

end
