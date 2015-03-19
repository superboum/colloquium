module MainController
  def self.registered(app)
    # FRONTOFFICE

    app.get '/?' do
      articles = Article.order(:created_at)
      events = Event.order(:start_date)
      haml :'home', :locals => { :articles => articles, :events => events }
    end

    app.get '/login/?' do
      restrictToNotAuthenticated!
      haml :login
    end

    app.get '/logout' do
      session[:user] = nil
      redirect to('/'),303
    end

    app.post '/login' do
      restrictToNotAuthenticated!

      if params['action'] == 'login' then
        if logUser(params['email'],params['password']) then 
          redirect to('/'), 303
        else
          redirect to('/login'),303
        end
      else

      end
    end

    # BACKOFFICE
    app.get '/admin/?' do
      restrictToAdmin!
      articles = Article.all
      events = Event.all
      users = User.all
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/home', :locals => { :articles => articles, :events => events, :users => users}
      end
    end
  end
end
