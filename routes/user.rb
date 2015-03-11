class UserController < BaseController
  # BACKOFFICE
  get '/admin/user/?' do
    restrictToAdmin!
    users=User.all
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/user/home' ,:locals => { :users => users }
    end
  end

  get '/admin/user/new/?' do
    restrictToAdmin!
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/user/newedit', :locals => { :user => User.new, :edit => false }
    end
  end

  post '/admin/user/new' do
    restrictToAdmin!
    user = User.new
    user.first_name = params['first_name']
    user.last_name = params['last_name']
    user.email = params['email']
    user.password = Digest::SHA256.hexdigest(params['password'])
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

  get '/admin/user/delete/:id/?' do
    restrictToAdmin!
    user = User.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/user/delete', :locals => { :user => user }
    end
  end

  post '/admin/user/delete/:id' do
    restrictToAdmin!
    User.destroy(params[:id])
    redirect "/admin/user", 303
  end

  get '/admin/user/edit/:id/?' do
    restrictToAdmin!
    user = User.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/user/newedit', :locals => { :user => user, :edit => true }
    end
  end

  post '/admin/user/edit/:id' do
    restrictToAdmin!
    user = User.find(params[:id])
    user.first_name = params['first_name']
    user.last_name = params['last_name']
    user.email = params['email']
    user.password = Digest::SHA256.hexdigest(params['password'])
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
