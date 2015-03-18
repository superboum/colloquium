require 'sinatra/activerecord'

class Event < ActiveRecord::Base
	validates :short_text, length: { maximum: 255 }
end
