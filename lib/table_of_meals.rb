class TableOfMeals
	@store
	@table
	@first_day
	@current_day
	@current_m
	@current_line
	@store_empty
	def table
		return @table
	end

	def initialize
		@store_empty = false
		begin
			@store = Meal.get_info_from_store
		rescue
			@store_empty=true
		end
		unless @store_empty
			@table = Array.new
			@first_day = @store["first_day" ]
			@last_day = @store["last_day" ]
			@day = @first_day
			@current_line = []
		end
		
	end

	def push_meals_type
		@current_line = Array.new
		@current_line << ""
		for i in 0..2
			elt = Meal.convert_int_to_string(i)
			if(@store[elt])
				@current_line<<elt.capitalize
			end
		end
		@table<<@current_line
		
	end


	def each
		unless @store_empty

			push_meals_type


			for @current_day in @first_day..@last_day
				iterate_over_line(&Proc.new)
			end
		end
	end





	def fill_case_of_table
		elt = Meal.convert_int_to_string(@current_m)
		if(@store[elt])
			meal,meal_exists = Meal.create_or_find(@current_day,@current_m)
			if meal.in_range?(@store)
				yield @current_line, meal,meal_exists , @store
			else
				@current_line<<nil
			end
			return !@current_line.last.nil?
		end
	end

	def iterate_over_line
		
		empty_line=true
		@current_line = Array.new

		for @current_m in 0..2
			if fill_case_of_table(&Proc.new)
				empty_line = false
			end
		end
		
		unless empty_line
			@table<<[@current_day.strftime("%d/%m/%Y")].concat(@current_line)
		end
	end

	#================================
	#================================
	#===========  GETTERS  ==========
	#================================
	#================================

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
			line<<[m,meal_exists && store[Meal.convert_int_to_string(m)]]
			
		end
		return tom.table
	end
end

