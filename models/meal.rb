require 'sinatra/activerecord'

class Meal < ActiveRecord::Base
	has_many :users_meals
	has_many :participants, through: :users_meals, source: :user

	@@MEAL={"breackfast" => 0,"lunch" => 1,"dinner" => 2}

	def self.MEAL
		@@MEAL
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
				errors["last_day"] = "can not be sooner than first date"
			end
			if  ( Date.parse(params["first_day"]) == Date.parse(params["last_day"]) )&& (params["first_meal"] > params["last_meal"])
				errors["last_meal"] = "can not be sooner than first date"
			end
		end
		errors = errors
		params["errors"]= errors

		return params
	end

	def self.create_meal(d,m)
		meal = Meal.new
		meal.day = d
		meal.meal = m
		return meal
	end

	def in_range?(*store)
		store = nil
		if(store.nil?)
			store = YAML.load_file('config/general.yml')
		else 
			if (store.is_a?(Array))
				store = store[0]
			end
		end


		first_day= Date.parse(store["meal"]["first_day"])
		last_day= Date.parse(store["meal"]["last_day"])
		first_meal= store["meal"]["first_meal"]
		last_meal = (store["meal"]["last_meal"])

		if(self.day >= first_day)
			if(self.day==first_day&&self.meal<first_meal)	
				return false
			end


			if(self.day < last_day)
				return true
			else 
				if(self.day==last_day)
					return self.meal <= last_meal
				end
			end

		end

	end

	def self.get_nb_of_days(*store)
		if(store.nil?)
			store = YAML.load_file('config/general.yml')
		else 
			store = store[0]
		end

		first_day= Date.parse(store["meal"]["first_day"])
		last_day= Date.parse(store["meal"]["last_day"])

		return  ((last_day - first_day)).to_i

	end


	def self.store(params,app)
		
		store = YAML::Store.new "config/general.yml"
		
		store.transaction do

			store["meal"] = { 
				"first_day" => params["first_day"],
				"first_meal"  => params["first_meal"].to_i,
				"last_day"  => params["last_day"],
				"last_meal" => params["last_meal"].to_i,
				"breackfast" => !params["breackfast"].nil?,
				"lunch" => !params["lunch"].nil?,
				"dinner" => !params["dinner"].nil?,
			}
		end
		app.config_file 'config/general.yml'
	end

	def self.get_table_of_meal_number
		return	meal = Meal.iterate_over_table 	do |line, db_meal, current_meal, store, empty_line_array|

			m = current_meal.meal
			if current_meal.in_range?(store)
				if(!db_meal.nil?)
					p db_meal.participants

					line[m+1]=db_meal.participants.count
				end
			end

			if(!line[m+1].nil?)
				empty_line_array[0] = false
			end
		end

	end

	def self.get_table_of_meals
		return	meal = Meal.iterate_over_table 	do |line, db_meal, current_meal, store, empty_line_array|

			m = current_meal.meal
			if current_meal.in_range?(store)
				empty_line_array[0] = false
				if(!db_meal.nil?)
					line[m+1]=store["meal"][Meal.convert_int_to_string(m)]
				else 
					line[m+1]=false
				end

				if(!line[m+1].nil?)
					empty_line_array[0] = false
				end
			end
		end
	end

	def self.iterate_over_table(*u)

		store = YAML.load_file('config/general.yml')

		first_day= Date.parse(store["meal"]["first_day"])
		last_day= Date.parse(store["meal"]["last_day"])

		
		
		table = Array.new


		for day in first_day..last_day
			empty_line=true
			line= Array.new(4)
			line[0]=day.strftime("%d/%m/%Y")
			for m in 0..2
				#From the database
				db_meal = Meal.where(day: day,meal: m).first

				#actual day in iteration
				current_meal = Meal.create_meal(day,m)

				empty_line_array = [empty_line]
				yield  line, db_meal, current_meal,store,empty_line_array
				empty_line = empty_line_array[0]
				end
			if(!empty_line)
				table<<line
			end


		end
		return table
	end



	def self.create_meals(first_day,last_day,breackfast,lunch,dinner)
		for day in first_day..last_day
			for m in 0..2

				continue = true

				case m 
				when Meal.MEAL["breackfast"]
					if breackfast.nil?
						continue = false
					end
				when Meal.MEAL["lunch"]
					if lunch.nil?
						continue = false
					end
				when Meal.MEAL["dinner"]
					if dinner.nil?
						continue = false
					end
				end

				if(continue)
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
end
