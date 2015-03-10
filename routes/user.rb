class UserController < BaseController
  # BACKOFFICE
  get '/admin/user' do
	users=User.all
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/user/home' ,:locals => { :users => users }
    end
  end

  get '/admin/user/new' do
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/user/newedit', :locals => { :user => User.new, :edit => false }
    end
  end

  post '/admin/user/new' do
    user = User.new
    user.first_name = params['first_name']
    user.last_name = params['last_name']
    user.email = params['email']
	user.password = Digest::SHA256.hexdigest("#{params['password']}")
    user.phone = params['phone']
    user.save
    redirect "/admin/user", 303
  end

end
