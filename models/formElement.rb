require 'sinatra/activerecord'

class FormElement < ActiveRecord::Base

	@@TYPES={"bool" => 0,"select" => 1,"string" => 2}
	
	def self.TYPES
		@@TYPES
	end
	validates_inclusion_of :form_type, :in => 0..2
end
