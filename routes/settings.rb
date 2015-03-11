class SettingsController < BaseController
  # BACKOFFICE
  get '/admin/settings/?' do
    restrictToAdmin!
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/setting/home'
    end
  end
end
