require 'sinatra/activerecord'

class FormAnswer < ActiveRecord::Base
	belongs_to :form_element
	belongs_to :event
	belongs_to :participant, :class_name => 'User', :foreign_key => 'participant_id'
end
