require 'sinatra/activerecord'

class Event < ActiveRecord::Base
	validates :short_text, length: { maximum: 255 }

	def get_felts
		return FormElement.where(event_id: self.id)
	end

end
