require 'sinatra/activerecord'

class FormElement < ActiveRecord::Base

	has_many :form_answers, :class_name => 'FormAnswer', :foreign_key => 'form_element_id',dependent: :delete_all
	belongs_to :event

	@@TYPES={"bool" => 0,"select" => 1,"string" => 2}
	
	def self.TYPES
		@@TYPES
	end
	validates_inclusion_of :form_type, :in => 0..2
    
      

	def set_params_with_id(params, event)
		self.question= params['question::'+self.id.to_s]
        self.form_type = params["form_type::"+self.id.to_s]
        self.event = event
        if self.form_type == FormElement.TYPES["select"]
          self.data=params["dataSelect::"+self.id.to_s]
        end

    end

    def set_params(params)
        self.question = params["question"]
        self.form_type = params["form_type"]
        self.event_id = params["event"]
        if self.form_type == FormElement.TYPES["select"]
            self.data=params["dataSelect"]
        end

    end

    def edit_answer(params,user)
    	fa=FormAnswer.where(form_element: self, participant: user).first
    	newFormAnswer = (fa==nil)
    	if(newFormAnswer)
    		fa=FormAnswer.new
    		fa.form_element = self
    		fa.event=self.event
    		fa.participant = user
    	end
    	fa.set_answer(params,self)

    	fa.participant = user
    	fa.save
    end

	def answer(params,user)
		fa = FormAnswer.new
		fa.form_element = self
		fa.event = self.event
		fa.participant = user


		fa.set_answer(params,self)
		fa.save

	end

end
