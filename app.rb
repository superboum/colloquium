require 'sinatra'
require 'haml'
require 'sinatra/activerecord'
require_relative 'models/init'

class ColloquiumApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :database, {adapter: "sqlite3", database: "app.db"}
   
    helpers do
      def getPages()
        Page.all
      end
    end
   
    ### FRONTEND ###

    get '/' do
        articles = Article.all
        events = Event.order(:begin)
        haml :home, :locals => { :articles => articles, :events => events }
    end
    
    get '/article/:id' do
        article = Article.find_by_id(params[:id])
        haml :article, :locals => { :article => article }
    end
    
    get '/events/:id' do
        event = Event.find_by_id(params[:id])
        haml :event, :locals => { :event => event }
    end

    get '/page/:id' do
      page = Page.find(params[:id])
      haml :page, :locals => { :page => page } 
    end

	get '/login' do
	  haml :login
	end

    ### BACKEND ###
    
    get '/admin' do
        articles = Article.all
        events = Event.all
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/home', :locals => { :articles => articles, :events => events}
        end
    end

    # ARTICLE #
    get '/admin/article' do
        articles = Article.all
        haml :'admin/layout', :layout => :'layout'  do
          haml :'admin/article/home', :locals => { :articles => articles }
      end
    end

    get '/admin/article/new' do
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/article/newedit', :locals => { :article => Article.new, :edit => false }
      end
    end

    post '/admin/article/new' do
        article = Article.new
        article.title = params['title']
        article.category = params['category']
        article.short_text = params['short_text']
        article.long_text = params['long_text']
        article.save
        redirect "/admin/article", 303
    end

    get '/admin/article/edit/:id' do
        article = Article.find(params[:id])
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/article/newedit', :locals => { :article => article, :edit => true }
        end

    end
    
    post '/admin/article/edit/:id' do
        article = Article.find(params[:id])
        article.title = params['title']
        article.category = params['category']
        article.short_text = params['short_text']
        article.long_text = params['long_text']
        article.save
        redirect "/admin/article", 303
    end

    get '/admin/article/delete/:id' do
        article = Article.find(params[:id])
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/article/delete', :locals => { :article => article }
        end
    end
    
    post '/admin/article/delete/:id' do
        Article.destroy(params[:id])
        redirect "/admin/article", 303
    end


    # PAGE #
    get '/admin/page' do
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/home'
      end
    end

    get '/admin/page/new' do
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/newedit', :locals => { :page => Page.new, :edit => false }
      end
    end

    post '/admin/page/new' do
        page = Page.new
        page.title = params['title']
        page.category = params['category']
        page.author = params['author']
        page.long_text = params['long_text']
        page.priority = params['priority']
        page.save
        redirect "/admin/page", 303
    end


    get '/admin/page/edit/:id' do
        page = Page.find(params[:id])
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/page/newedit', :locals => { :page => page, :edit => true }
        end
    end

    post '/admin/page/edit/:id' do
        page = Page.find_by_id(params[:id])
        page.title = params['title']
        page.category = params['category']
        page.author = params['author']
        page.long_text = params['long_text']
        page.priority = params['priority']
        page.save
        redirect "/admin/page", 303
    end

    get '/admin/page/delete/:id' do
        page = Page.find(params[:id])
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/page/delete', :locals => { :page => page }
        end
    end

    post '/admin/page/delete/:id' do
        Page.destroy(params[:id])
        redirect "/admin/page", 303
    end

    # EVENTS #
    get '/admin/event' do
        events = Event.all
        haml :'admin/layout', :layout => :'layout'  do
          haml :'admin/event/home', :locals => { :events => events }
        end
    end
    get '/admin/event/new' do
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/event/newedit', :locals => { :event => Event.new, :edit => false }
      end
    end

    post '/admin/event/new' do
        event = Event.new
        event.title = params['title']
        event.short_text = params['short_text']
        event.begin = params['begin']
        event.end = params['end']
        event.save
        redirect "/admin/event", 303
    end


    get '/admin/event/edit/:id' do
        event = Event.find(params[:id])
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/event/newedit', :locals => { :event => event, :edit => true }
        end

    end
    

    post '/admin/event/edit/:id' do
        event = Event.find(params[:id])
        event.title = params['title']
        event.short_text = params['short_text']
        event.begin = params['begin']
        event.end = params['end']
        event.save
        redirect "/admin/event", 303
    end

    get '/admin/event/delete/:id' do
        event = Event.find(params[:id])
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/event/delete', :locals => { :event => event }
        end
    end
    
    post '/admin/event/delete/:id' do
        Event.destroy(params[:id])
        redirect "/admin/event", 303
    end
    
    # REVIEWS #
    get '/admin/review' do
        haml :'admin/layout', :layout => :'layout'  do
          haml :'admin/review/home'
        end
    end

    # USERS #
    get '/admin/user' do
        haml :'admin/layout', :layout => :'layout'  do
          haml :'admin/user/home'
        end
    end

    # SETTINGS #
    get '/admin/settings' do
        haml :'admin/layout', :layout => :'layout'  do
          haml :'admin/setting/home'
      end
    end

end
