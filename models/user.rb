require 'sinatra/activerecord'

class User < ActiveRecord::Base
	def registered?(event)
		return (User.find_by_sql ['SELECT u.* FROM users AS u,
												registered_users_to_events AS r
								  WHERE u.id = ? AND 
								  		r.user_id = u.id AND
								  		r.event_id = ?',self.id,event.id]).length >= 1 
	
	end
end

