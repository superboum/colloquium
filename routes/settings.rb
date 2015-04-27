module SettingsController

  def self.registered(app) # <-- a method yes, but really a hook
    # BACKOFFICE
    app.get '/admin/settings/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/setting/home', :locals => { :store => YAML.load_file('config/general.yml') }
      end
    end

    app.post '/admin/settings/?' do
      restrictToAdmin!
	  store = YAML::Store.new "config/general.yml"
	  store.transaction do
      store["parameters"] = { 
        "base_url" => params["base_url"],
        "title"  => params["title"],
        "slogan" => params["slogan"],
        "cover" => params["cover"],
      }
      store['payment'] = { 'rib' => params['rib'] }
	  end
      redirect "/admin/settings", 303
	end
  end
end
