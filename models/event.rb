require 'sinatra/activerecord'

class Event < ActiveRecord::Base

  has_many :form_answers, :class_name => 'FormAnswer', :foreign_key => 'event_id',:dependent => :delete_all
  has_many :form_elements, :class_name => 'FormElement', :foreign_key => 'event_id',:dependent => :delete_all
  has_many :users_events
  has_many :participants, through: :users_events
  belongs_to :admin, :class_name => 'User', :foreign_key => 'admin_id'

	validates :short_text, length: { maximum: 255 }

	def get_felts
		return self.form_elements
	end

	def set(params,user)
		self.name = params['name']
    self.short_text = params['short_text']
    self.long_text = params['long_text']
    self.start_date = params['start_date']
    self.end_date = params['end_date']
    self.registration= params['registration']=="1"
    self.spots_number_limit = params["place_number"]
    self.admin = user

	end


  

	def set_felts(params,user)
		  
    self.form_elements.each do |felt|
      if(params["delete::"+felt.id.to_s]=='1')
        felt.destroy 
      else  
        felt.question= params['question::'+felt.id.to_s]
        felt.form_type = params["form_type::"+felt.id.to_s]
        felt.event = self
        if felt.form_type == FormElement.TYPES["select"]
          felt.data=params["dataSelect::"+felt.id.to_s]
        end
        felt.save
      end
    end
  end
end
