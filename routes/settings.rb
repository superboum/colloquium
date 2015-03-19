module SettingsController
  def self.registered(app) # <-- a method yes, but really a hook
    # BACKOFFICE
    app.get '/admin/settings/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/setting/home'
      end
    end
  end
end
