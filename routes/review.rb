class ColloquiumApp < Sinatra::Application

  get '/profile/review/?' do
    restrictToAuthenticated!
    haml :'profile/layout', :locals => { :menu => 2 }, :layout => :'layout'  do
      haml :'profile/review'
    end
  end

  # BACKOFFICE
  get '/admin/review/?' do
    restrictToAdmin!
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/review/home'
    end
  end
end
