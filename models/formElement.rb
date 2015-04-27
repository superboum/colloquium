require 'sinatra/activerecord'

class FormElement < ActiveRecord::Base

	has_many :form_answers, :class_name => 'FormAnswer', :foreign_key => 'form_element_id',dependent: :delete_all
	belongs_to :event

	@@TYPES={"bool" => 0,"select" => 1,"string" => 2}
	
	def self.TYPES
		@@TYPES
	end
	validates_inclusion_of :form_type, :in => 0..2


	def set(params, event)
		self.question= params['question::'+self.id.to_s]
        self.form_type = params["form_type::"+self.id.to_s]
        self.event = event
        if self.form_type == FormElement.TYPES["select"]
          self.data=params["dataSelect::"+self.id.to_s]
        end
        self.save

    end

end
