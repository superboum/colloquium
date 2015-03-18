class ColloquiumApp < Sinatra::Application
  # FRONTOFFICE

  get '/?' do
    articles = Article.order(:created_at)
    events = Event.order(:start_date)
    haml :'home', :locals => { :articles => articles, :events => events }
  end

  get '/login/?' do
    restrictToNotAuthenticated!
    haml :login
  end
  
  get '/logout' do
    session[:user] = nil
    redirect to('/'),303
  end

  post '/login' do
    restrictToNotAuthenticated!
    email_in = params['emailSI']
    rawPassword = params['InputPasswordSI']
    password_in = Digest::SHA256.hexdigest(rawPassword)

    user = User.find_by email: email_in

    if user != nil and user.password == password_in then
      puts "User " + user.email + " is now logged"
      session[:user] = user.id
      redirect to('/'), 303
    else
      redirect to('/login'),303
    end
  end

  # BACKOFFICE
  get '/admin/?' do
    restrictToAdmin!
    articles = Article.all
    events = Event.all
    users = User.all
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/home', :locals => { :articles => articles, :events => events, :users => users}
    end
  end
end
