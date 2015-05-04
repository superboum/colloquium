module MealStore
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

end