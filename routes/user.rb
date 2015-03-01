class UserController < BaseController
  # BACKOFFICE
  get '/admin/user' do
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/user/home'
    end
  end
end
