module UserController
  def self.registered(app) # <-- a method yes, but really a hook
    # USERSIDE
    app.get '/profile/account/?' do
      restrictToAuthenticated!
      haml :'profile/layout', :locals => { :menu => 0 }, :layout => :'layout'  do
        haml :'profile/account'
      end
    end

    app.post '/profile/account/?' do
      restrictToAuthenticated!
      puts "has to put fist name in data base of #{user.email} first name : #{user.first_name}"
      user.first_name = params["firstName"]
      puts "first_name done"
      user.last_name = params["lastName"]
      puts "lastName : #{user.last_name} = #{params["lastName"]}"
      user.title = params["title"]
      user.sex = params["gender"]
      user.nationality = params["nationality"]
      user.phone = params["phone"]
      user.address = params["address"]
      user.diet= params["dietRadioOptions"]
      user.save
      puts "#{params['first_name']} = #{user.first_name}"
      redirect "/profile/account/?", 303
    end


    app.get '/profile/password_lost/?' do
      restrictToNotAuthenticated!
      haml :'profile/password_lost'
    end

    app.post '/profile/password_lost/?' do
      restrictToNotAuthenticated!
      u = User.find_by email: params[:email]
      if u.instance_of? User then
        u.lost_password()
        u.save
      end
      redirect to('/profile/password_lost'),303
    end

    app.get '/profile/password_change/:email/:token/?' do
      u = User.find_by email: params[:email]
      puts u
      puts params[:email]
      puts params[:token]
      if u.instance_of? User and u.check_token params[:token] then
        u.save
        logUserManually(u)
        redirect to('/profile/parameters'),303
      end
      redirect to('/'),303
    end

    app.get '/profile/parameters/?' do
      restrictToAuthenticated!
      haml :'profile/parameters'
    end

    app.post '/profile/parameters/?' do
      restrictToAuthenticated!
      if params['password1'] == params['password2'] then
        user.raw_password params['password1']
        user.save
      end

      haml :'profile/parameters'
    end


    app.get '/profile/delete/?' do
      restrictToAuthenticated!
      user.destroy
      session[:user] = nil
      redirect to('/'),303
    end

    # BACKOFFICE
    app.get '/admin/user/?' do
      restrictToAdmin!
      users=User.all
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/user/home' ,:locals => { :users => users }
      end
    end

    app.get '/admin/user/new/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/user/newedit', :locals => { :user => User.new, :edit => false }
      end
    end

    app.post '/admin/user/new' do
      restrictToAdmin!
      user = User.new
      user.first_name = params['first_name']
      user.last_name = params['last_name']
      user.email = params['email']
      user.raw_password params['password']
      user.phone = params['phone']
      user.address = params['address']
      user.role = params['role']
      user.diet = params['diet']
      user.nationality = params['nationality']
      user.title = params['title']
      user.sex = params['sex']
      user.has_paid = params['has_paid']
      user.save
      redirect "/admin/user", 303
    end

    app.get '/admin/user/delete/:id/?' do
      restrictToAdmin!
      user = User.find(params[:id])
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/user/delete', :locals => { :user => user }
      end
    end

    app.post '/admin/user/delete/:id' do
      restrictToAdmin!
      User.destroy(params[:id])
      redirect "/admin/user", 303
    end

    app.get '/admin/user/edit/:id/?' do
      restrictToAdmin!
      user = User.find(params[:id])
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/user/newedit', :locals => { :user => user, :edit => true }
      end
    end
    
    app.get '/admin/user/impersonate/:id/?' do
      restrictToAdmin!
      u = User.find(params[:id])
      logUserManually(u)
      redirect "/", 303
    end

    app.post '/admin/user/edit/:id' do
      restrictToAdmin!
      user = User.find(params[:id])
      user.first_name = params['first_name']
      user.last_name = params['last_name']
      user.email = params['email']
      if params['password'] != "" then
        user.raw_password params['password']
      end
      user.phone = params['phone']
      user.address = params['address']
      user.role = params['role']
      user.diet = params['diet']
      user.nationality = params['nationality']
      user.title = params['title']
      user.sex = params['sex']
      user.has_paid = params['has_paid']
      user.save
      redirect "/admin/user", 303
    end

  end
end
