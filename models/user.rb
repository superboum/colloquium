require 'sinatra/activerecord'

class User < ActiveRecord::Base
	def registered?(event)
		return (User.find_by_sql ['SELECT u.* FROM users AS u,
												users_form_answers AS ufa,
												form_answers AS fa,
												form_elements AS fe,
												events AS e 
								  WHERE u.id = ? AND 
								  		ufa.users_id = u.id AND
								  		ufa.form_answers_id = fa.id AND 
								  		fa.form_elements_id = fe.id AND 
								  		fe.event_id = ?',self.id,event.id]).length >= 1 
	end
end
