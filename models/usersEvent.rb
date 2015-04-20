require 'sinatra/activerecord'

class UsersEvent < ActiveRecord::Base
	belongs_to :user
	belongs_to :event
end