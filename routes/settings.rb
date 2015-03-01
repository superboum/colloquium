class SettingsController < BaseController
    # BACKOFFICE
    get '/admin/settings' do
        haml :'admin/layout', :layout => :'layout'  do
          haml :'admin/setting/home'
      end
    end
end
