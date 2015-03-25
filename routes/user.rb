module UserController
  def self.registered(app) # <-- a method yes, but really a hook
    # USERSIDE
    app.get '/profile/account/?' do
      restrictToAuthenticated!
      haml :'profile/layout', :locals => { :menu => 0 }, :layout => :'layout'  do
        haml :'profile/account'
      end
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
