module SettingsController

  def self.registered(app) # <-- a method yes, but really a hook
    # BACKOFFICE
    app.get '/admin/settings/?' do
      store = YAML::Store.new "config/general.yml"
      restrictToAdmin!
      base_url = store.transaction { store["parameters"]["base_url"] }
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/setting/home', :locals => { :base_url => base_url }
      end
    end

    app.post '/admin/settings/?' do
      restrictToAdmin!
	  store = YAML::Store.new "config/general.yml"
	  store.transaction do
		store["parameters"] = { "base_url" => params["base_url"]}
	  end
      redirect "/admin/settings", 303
	end
  end
end
