require 'sinatra/activerecord'

class Meal < ActiveRecord::Base
	has_many :users_meals, dependent: :delete_all
	has_many :participants, through: :users_meals, source: :user

	@@MEAL={"breackfast" => 0,"lunch" => 1,"dinner" => 2}

#INSTANCE METHODES

	def in_range?(*store)
		store = Meal.get_info_from_store(store)
		if(self.day >=(store["first_day" ]))
			if(self.day==store["first_day" ]&&self.meal<store["first_meal" ])	
				return false
			end
			if(self.day <  (store["last_day" ]))
				return true
			else 
				if(self.day== (store["last_day" ]))
					return self.meal <= (store["last_meal" ])
				else 
					return false
				end
			end

		end

	end


	#GLOBAL METHODES
	def self.MEAL
		@@MEAL
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
		for day in first_day..last_day
			for m in 0..2
				if(!meal_type[m].nil?)
					if(!Meal.where(day: day,meal: m).exists?)
						meal = Meal.new
						meal.day=day
						meal.meal= m
						if(meal.in_range? )
							meal.save
						end
					end
				end
			end
		end
	end

	def self.convert_int_to_string(m)
		case m
		when Meal.MEAL["breackfast"]
			return "breackfast"
		when Meal.MEAL["lunch"]
			return "lunch"
		when Meal.MEAL["dinner"]
			return "dinner"
		else
			return "undefined"
		end
	end

	def self.check_params(params)
	errors ={}
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


		if errors.empty?
			if Date.parse(params["first_day"]) > Date.parse(params["last_day"])
				errors["last_day"] = "cannot be sooner than first date"
			end
			if  ( Date.parse(params["first_day"]) == Date.parse(params["last_day"]) )&& (params["first_meal"] > params["last_meal"])
				errors["last_meal"] = "cannot be sooner than first date"
			end
		end
		errors = errors
		params["errors"]= errors

		return params
	end


	def self.get_info_from_store(*store)
		if(store.all? &:blank?)
			store = YAML.load_file('config/general.yml')["meal"]
			store["first_day"]=Date.parse(store["first_day"])
			store["last_day"]=Date.parse(store["last_day"])
		else 
			while(store.is_a?(Array))
				store = store[0]
			end
		end

		ret = {"first_day" => store["first_day"],
			"last_day" => store["last_day"],
			"first_meal" => store["first_meal"],
			"last_meal" => store["last_meal"],
			"breackfast" => store["breackfast"],
			"lunch" => store["lunch"],
			"dinner" => store["dinner"],

		}

		return ret

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

		return	meal = Meal.iterate_over_table 	do |line, meal,meal_exists, store|

			if(meal_exists)
				m = meal.meal
				line<<[m,meal.participants.count]
			else
				line << [m,nil]
			end
			
		end

	end

	def self.get_table_of_meals

		return	meal = Meal.iterate_over_table 	do |line, meal,meal_exists, store|
			m = meal.meal
			line<<[m,meal_exists && store[Meal.convert_int_to_string(m)]]
			
		end
	end

	def self.get_meals_type(*store)
		store = get_info_from_store(store)
		line = Array.new
		line << ""
		for i in 0..2
			elt = Meal.convert_int_to_string(i)
			if(store[elt])
				line<<elt.capitalize
			end
		end
		return line
		
	end


	def self.iterate_over_table(*u)

		store = get_info_from_store
		table = Array.new
		table << Meal.get_meals_type(store)
		for day in store["first_day" ]..store["last_day"]

			empty_line=true
			line = Array.new

			for m in 0..2
				elt = Meal.convert_int_to_string(m)
				if(store[elt])
					meal,meal_exists = Meal.create_or_find(day,m)

					if meal.in_range?(store)
						yield  line, meal,meal_exists , store
					else
						line<<nil
					end
					unless(line.last.nil?)
						empty_line = false
					end
				end
			end
			if(!empty_line)
				table<<[day.strftime("%d/%m/%Y")].concat(line)
			end

		end
		return table
	end


	
end
