class MainController < BaseController
  # FRONTOFFICE
  get '/?' do
    articles = Article.all
    events = Event.order(:start_date)
    haml :'home', :locals => { :articles => articles, :events => events }
  end

  get '/login/?' do
    haml :login
  end

  post '/login' do
	email_in=params['emailSI']
	rawPassword=params['InputPasswordSI']
	password_in=Digest::SHA256.hexdigest("#{rawPassword}")
	if User.where(email:email_in ,password:password_in).count == 1 then
		redirect to('/'), 303
	else
		redirect to('/login'),303
	end
  end

  # BACKOFFICE
  get '/admin/?' do
    articles = Article.all
    events = Event.all
	users = User.all
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/home', :locals => { :articles => articles, :events => events, :users => users}
    end
  end
end
