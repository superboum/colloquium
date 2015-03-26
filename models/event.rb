require 'sinatra/activerecord'

class Event < ActiveRecord::Base
	validates :short_text, length: { maximum: 255 }

	def get_felts
		return FormElement.where(event_id: self.id)
	end

	def set(params,user)
		self.name = params['name']
    self.short_text = params['short_text']
    self.start_date = params['start_date']
    self.end_date = params['end_date']
    self.place_number = params['place_number']
    self.registration= params['registration']=="1"
    self.user_id = user.id

	end

	def set_felts(params,user)
		felts = self.get_felts
      
    felts.each do |felt|
      if(params["delete::"+felt.id.to_s]=='1')
        FormAnswer.where(form_elements_id: felt.id).destroy_all
        felt.destroy
      else  
        felt.question= params['question::'+felt.id.to_s]
        felt.form_type = params["form_type::"+felt.id.to_s]
        felt.event_id = params["event::"+felt.id.to_s]
        if felt.form_type == FormElement.TYPES["select"]
          felt.data=params["dataSelect::"+felt.id.to_s]
        end
        felt.save
      end
    end
  end
end
