require 'sinatra/activerecord'

class FormElement < ActiveRecord::Base
	@@TYPE_BOOL = 0
	@@TYPE_CHOICE = 1
	@@TYPE_STRING = 2
	class << self
		attr_accessor :TYPE_STRING,:TYPE_CHOICE,:TYPE_BOOL
	end

	validates_inclusion_of :type, :in => 0..2
end
