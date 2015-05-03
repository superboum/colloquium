module MealController





  def self.registered(app) # <-- a method yes, but really a hook

    # USER SIZE

    app.get '/profile/meal/?' do
      restrictToAuthenticated!
      haml :'profile/layout', :locals => { :menu => 1 }, :layout => :'layout'  do
        haml :'profile/meal', :locals => { table: user.get_table_of_meals }
      end
    end 

    app.post '/profile/meal/?' do
      restrictToAuthenticated!
      user.register_to_meal(params["meals"])
      redirect '/profile/event', 303
    end

    # BACKOFFICE
    
    app.get '/admin/settings/meals/?' do
      restrictToAdmin!
      redirect '/admin/settings/meals/date'
    end
   
    app.get '/admin/settings/meals/date/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/setting/meal_date', :locals => { :store => YAML.load_file('config/general.yml') , valid: true, meal: Meal.MEAL}
      end
    end

    app.post '/admin/settings/meals/date/?' do
      restrictToAdmin!
      

      tmp=Meal.check_params(params)
      params = tmp

      unless (params["errors"].all? &:blank?)
        haml :'admin/layout', :layout => :'layout'  do
          haml :'admin/setting/meal_date', :locals => { :store => YAML.load_file('config/general.yml') , valid: false, params: params, meal: Meal.MEAL}
        end
      else

        Meal.store(params,app)

        first_day = Date.parse(params["first_day"])
        last_day = Date.parse(params["last_day"])

        Meal.create_meals(first_day,last_day,[params["breackfast"],params["lunch"],params["dinner"]])

        redirect "/admin/settings/meals/selection"
      end
    end


    app.get '/admin/settings/meals/selection/?' do
      restrictToAdmin!
      
      store = YAML.load_file('config/general.yml')
      table =Meal.get_table_of_meals

      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/setting/meal_select', :locals => { first_day: Date.parse(store["meal"]["first_day"]),last_day: Date.parse(store["meal"]["last_day"]),table: table}
      end
    end

    app.post '/admin/settings/meals/selection/?' do
      restrictToAdmin!
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
      redirect '/admin', 303
   end

  end 
end
