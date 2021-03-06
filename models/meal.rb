require 'sinatra/activerecord'

class Meal < ActiveRecord::Base
	has_many :users_meals, dependent: :delete_all
	has_many :participants, through: :users_meals, source: :user

	@@MEAL={"breackfast" => 0,"lunch" => 1,"dinner" => 2}

#INSTANCE METHODES


	def day_upper_than(other_meal)
		return self.day > other_meal.day
	end

	def upper_than_by_meal(other_meal)
		return self.day == other_meal.day && self.meal > other_meal.meal
	end


	def upper_than(meal_to_compare)
		day,m = Meal.get_day_and_meal(meal_to_compare)
		if(self.day==day)
			return upper_than_by_meal(meal_to_compare)
		end
		return day_upper_than(meal_to_compare)
	end

	def lower_than(meal_to_compare)
		return !upper_than(meal_to_compare) && ! equal(meal_to_compare)
	end

	def equal(meal_to_compare)
		day,m = Meal.get_day_and_meal(meal_to_compare)
		return self.day == day && self.meal == m
	end

	def lower_or_equal_than(meal_to_compare)
		return !upper_than(meal_to_compare)
	end


	def upper_or_equal_than(meal_to_compare)
		return upper_than(meal_to_compare) || equal(meal_to_compare)
	end


	def in_range?(*store)

		store = MealStore.get_info_from_store(store)
	
		ret =	upper_or_equal_than(Meal.new(day: store["first_day"],meal: store["first_meal"])) &&
				lower_or_equal_than(Meal.new(day: store["last_day"],meal: store["last_meal"])) 

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

	def get_day_and_meal_in_view_format
		return [self.day.strftime("%d/%m/%Y"),self.meal.to_s]
	end

	def in_list_of_meal_in_view_format(list_of_meal_in_view_format)
		day,meal_type =get_day_and_meal_in_view_format
		unless list_of_meal_in_view_format.has_key?(day)
			return false
		else
			unless list_of_meal_in_view_format[day].has_key?(meal_type)
				return false
			end
		end
		return true
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
		store = MealStore.get_info_from_store(store)
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

	def self.get_meal_array(meal_type)
		ret = []
		for m in 0..2
			unless meal_type[m].nil?
				ret << m
			end
		end
		return ret
	end

	def self.create_meals(first_day,last_day,meal_type)
		ActiveRecord::Base.transaction do
			for day in first_day..last_day
				get_meal_array(meal_type).each do |m|
					meal = Meal.new
					meal.create_if_in_range({"meal_type" => m,"day" => day},meal_type)
				end
			end
		end
	end

	def self.correct_meals(params)
			Meal.all.each do |m|
				unless (m.in_list_of_meal_in_view_format(params["meals"]))
					m.destroy
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
		DateFunction.check_date_format(params,"first_day")
		DateFunction.check_date_format(params,"last_day")
	end

	def self.check_logic_date(params)
		first_meal = Meal.create(day: params["first_day"], meal: params["first_meal"])
		last_meal = Meal.create(day: params["last_day"], meal: params["last_meal"])
		if	first_meal.day_upper_than(last_meal)
			params["errors"]["last_day"] = "cannot be sooner than first date"
		end

		if  first_meal.upper_than_by_meal(last_meal)
			params["errors"]["last_meal"] = "cannot be sooner than first meal"
		end
	end

	def self.check_logic_date_if_no_error(params)
		if Stuff.is_blank(params["errors"])
			check_logic_date(params)
		end
	end	

	def self.check_params(params)
		params["errors"] = {}
		
		check_date_format(params)
		check_logic_date_if_no_error(params)

		return params
	end

end
