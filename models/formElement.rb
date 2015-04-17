require 'sinatra/activerecord'

class FormElement < ActiveRecord::Base

	has_many :form_answers, :class_name => 'FormAnswer', :foreign_key => 'form_element_id',dependent: :delete_all
	belongs_to :event

	@@TYPES={"bool" => 0,"select" => 1,"string" => 2}
	
	def self.TYPES
		@@TYPES
	end
	validates_inclusion_of :form_type, :in => 0..2



end
