require 'sinatra/activerecord'

class Meal < ActiveRecord::Base
	has_many :users_meals
	has_many :participants, through: :users_meals, source: :user

	def self.check_params(params)
		errors ={}

		p params
		#check params
		begin
			params["first_day"] = Date.parse(params["first_day"]).strftime("%d/%m/%Y")
		rescue
			errors["first_day"]="Wrong date format"
		end  

		begin
			params["last_day"] = Date.parse(params["last_day"]).strftime("%d/%m/%Y")
		rescue
			errors["last_day"]="Wrong date format"
		end  

		begin
			params["first_meal"] = Time.parse(params["first_meal"]).strftime("%Hh%M")
		rescue
			errors["first_meal"]="Wrong time format"
		end  

		begin
			params["last_meal"] = Time.parse(params["last_meal"]).strftime("%Hh%M")
		rescue
			errors["last_meal"]="Wrong time format"
		end  
		if errors.empty?
			if Date.parse(params["first_day"]) > Date.parse(params["last_day"])
				errors["last_day"] = "can not be sooner than first date"
			end
			if  ( Date.parse(params["first_day"]) == Date.parse(params["last_day"]) )&& (Time.parse(params["first_meal"]) > Time.parse(params["last_meal"]))
				errors["last_meal"] = "can not be sooner than first date"
			end
		end
		params["errors"] = errors
		
		p params
		return params
	end
end
