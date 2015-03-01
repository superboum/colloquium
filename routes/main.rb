class MainController < BaseController
  # FRONTOFFICE
  get '/' do
    articles = Article.all
    events = Event.order(:begin)
    haml :'home', :locals => { :articles => articles, :events => events }
  end

  get '/login' do
    haml :login
  end

  # BACKOFFICE
  get '/admin' do
    articles = Article.all
    events = Event.all
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/home', :locals => { :articles => articles, :events => events}
    end
  end
end
