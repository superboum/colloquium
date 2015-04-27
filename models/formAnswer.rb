require 'sinatra/activerecord'

class FormAnswer < ActiveRecord::Base
	belongs_to :form_element
	belongs_to :event
	belongs_to :participant, :class_name => 'User', :foreign_key => 'participant_id'


	def set_answer(params,felt)
		id="felt::#{felt.id}"
		case felt.form_type
		when FormElement.TYPES["bool"]
			if(params[id]=="1")
				self.answer="true"
			else 
				self.answer = "selflse"
			end
		when FormElement.TYPES["select"]
			self.answer =params[id]      
		when FormElement.TYPES["string"]
			self.answer = params[id]

		else
	        #TODO
	        puts "\033[31merror\033[0m"
	    end
	end
end
