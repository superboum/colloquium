module MainController
  def self.registered(app)
    # FRONTOFFICE

    app.get '/?' do
      articles = Article.order(created_at: :desc)
      events = Event.order(start_date: :desc)
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

    app.post '/sign_in' do
      restrictToNotAuthenticated!
      if logUser(params['email'],params['password']) then 
        redirect to('/'), 303
      else
        redirect to('/login'),303
      end
    end

    app.post '/sign_up' do
      restrictToNotAuthenticated!
      if params['password1'] != params['password2']
        redirect to('/login'), 303
      elsif User.find_by(email: params['email']) != nil
        redirect to('/login'), 303
      else
        u = User.new
        u.create_account params['email'], params['password1']
        u.save
        haml :'waiting_for_validation', :locals => { }
      end

    end

    app.get '/confirm/:email/:token' do
      u = User.find_by email: params[:email]
      if u.instance_of? User and u.check_token params[:token] then
        u.role = 0
        u.save
        logUserManually(u)
        redirect to('/profile/account'),303
      end
      redirect to('/login'),303
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
