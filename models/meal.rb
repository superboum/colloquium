require 'sinatra/activerecord'

class Meal < ActiveRecord::Base
	has_many :users_meals, dependent: :delete_all
	has_many :participants, through: :users_meals, source: :user

	@@MEAL={"breackfast" => 0,"lunch" => 1,"dinner" => 2}

#INSTANCE METHODES



	def upper_or_equal_than(meal_to_compare)
		day,m = Meal.get_day_and_meal(meal_to_compare)
		if(self.day >=day)
			if(self.day==day&&self.meal<m)	
				return false
			end
		else return false
		end
		return true
	end

	def lower_or_equal_than(meal_to_compare)
		day,m = Meal.get_day_and_meal(meal_to_compare)
		
		if(self.day <=day)
			if(self.day==day&&self.meal>m)	
				return false
			end
		else return false
		end
		return true
	end

	def in_range?(*store)
		store = Meal.get_info_from_store(store)
		ret =	upper_or_equal_than({"day" => store["first_day"],"meal" => store["first_meal"]}) &&
				lower_or_equal_than({"day" => store["last_day"],"meal" => store["last_meal"]}) 

		return ret
	end


	def create_if_in_range(params,meal_type)
		m = params["meal_type"]
		day = params["day"]
		unless (meal_type[m].nil?)
			unless (Meal.where(day: day,meal: m).exists?)
				self.day=day
				self.meal= m
				if(self.in_range? )
					self.save
				end
			end
		end
	end

	#GLOBAL METHODES

	def self.MEAL
		@@MEAL
	end

	def self.get_day_and_meal(meal)
		m = 0
		day = Time.now
		if(meal.is_a?(Meal))
			m = meal.meal
			day = meal.day
		else
			m = meal["meal"]
			day = meal["day"]
		end

		return [day,m]
	end	


	def self.get_nb_of_days(*store)
		store = get_info_from_store(store)
		return  ((store["last_day"] - store["first_day"])).to_i

	end

	def self.create_or_find(day,m)
		begin
			meal = Meal.where(day: day,meal: m).first!
			meal_exists = true
		rescue
			meal = Meal.new(day: day, meal: m)
			meal_exists = false
		end
		return [meal,meal_exists]
	end

	def self.create_meals(first_day,last_day,meal_type)
		ActiveRecord::Base.transaction do
			for day in first_day..last_day
				for m in 0..2
					meal = Meal.new
					meal.create_if_in_range({"meal_type" => m,"day" => day},meal_type)
				end
			end
		end
	end

	def self.correct_meals(params)
		ActiveRecord::Base.transaction do
			Meal.all.each do |m|
				day = m.day.strftime("%d/%m/%Y")
				meal_type = m.meal.to_s
				if(!params["meals"].has_key?(day))
					m.destroy
				else
					if(!params["meals"][day].has_key?(meal_type))
						m.destroy
					end
				end
			end
		end
	end

	def self.convert_int_to_string(m)
		case m
		when @@MEAL["breackfast"]
			return "breackfast"
		when @@MEAL["lunch"]
			return "lunch"
		when @@MEAL["dinner"]
			return "dinner"
		else
			return "undefined"
		end
	end

	def self.check_date_format(params)

		begin
			params["first_day"] = Date.parse(params["first_day"]).strftime("%d/%m/%Y")
		rescue
			params["errors"]["first_day"]="Wrong date format"
		end  

		begin
			params["last_day"] = Date.parse(params["last_day"]).strftime("%d/%m/%Y")
		rescue
			params["errors"]["last_day"]="Wrong date format"
		end  
	end

	def self.check_logic_date(params)
		if params["errors"].all? &:blank?
			if Date.parse(params["first_day"]) > Date.parse(params["last_day"])
				params["errors"]["last_day"] = "cannot be sooner than first date"
			end

			if  ( Date.parse(params["first_day"]) == Date.parse(params["last_day"]) )&& (params["first_meal"] > params["last_meal"])
				params["errors"]["last_meal"] = "cannot be sooner than first meal"

			end
		end
	end	

	def self.check_params(params)
		params["errors"] = {}
		
		check_date_format(params)
		check_logic_date(params)

		return params
	end

	def self.get_store(*store)
		if(store.all? &:blank?)
			store = YAML.load_file('config/general.yml')["meal"]
			store["first_day"]=Date.parse(store["first_day"])
			store["last_day"]=Date.parse(store["last_day"])
		else 
			while(store.is_a?(Array))
				store = store[0]
			end
		end

		return store
	end

	def self.get_info_from_store(*store)
		store = get_store

		return {"first_day" => store["first_day"],
			"last_day" => store["last_day"],
			"first_meal" => store["first_meal"],
			"last_meal" => store["last_meal"],
			"breackfast" => store["breackfast"],
			"lunch" => store["lunch"],
			"dinner" => store["dinner"],

		}


	end

	def self.store(params,app)
		
		store = YAML::Store.new "config/general.yml"
		
		store.transaction do

			store["meal"] = { 
				"first_day" => params["first_day"],
				"first_meal"  => params["first_meal"].to_i,
				"last_day"  => params["last_day"],
				"last_meal"  => params["last_meal"].to_i,
				"breackfast" => !params["breackfast"].nil?,
				"lunch" => !params["lunch"].nil?,
				"dinner" => !params["dinner"].nil?,
			}
		end
		app.config_file 'config/general.yml'
	end

	def self.get_table_of_meal_number
		

		tom = TableOfMeals.new
		tom.each 	do |line, meal,meal_exists, store|

			if(meal_exists)
				m = meal.meal
				line<<[m,meal.participants.count]
			else
				line << [m,nil]
			end
			
		end
		return tom.table

	end

	def self.get_table_of_meals
		tom = TableOfMeals.new
		tom.each 	do |line, meal,meal_exists, store|	
			m = meal.meal
			line<<[m,meal_exists && store[convert_int_to_string(m)]]
			
		end
		return tom.table
	end

	


	
end
