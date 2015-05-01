require 'sinatra/activerecord'

class UsersMeal < ActiveRecord::Base
	belongs_to :user
	belongs_to :meal
end