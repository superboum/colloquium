require 'sinatra'
require 'haml'
require 'sinatra/activerecord'
require_relative 'models/init'

class ColloquiumApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :database, {adapter: "sqlite3", database: "app.db"}

    get '/' do
        articles = Article.all
        pages = Page.all
        haml :home, :locals => { :articles => articles, :pages => pages  }
    end
    
    get '/article/:id' do
        article = Article.find_by_id(params[:id])
        haml :article, :locals => { :article => article }
    end

    get '/admin' do
        articles = Article.all
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/home', :locals => { :articles => articles }
        end
    end

    get '/admin/article' do
      articles = Article.all
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/article/home', :locals => { :articles => articles }
      end
    end

    get '/admin/article/new' do
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/article/new'
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

    get '/admin/article/edit' do
        haml :'admin/article/edit'
    end

    get '/admin/article/delete' do
        haml :'admin/article/delete'
    end


# Pages management

    get '/page/:id' do
      @pages = Page.all(:order => [:id])
      @thisone = Page.find_by_id(params[:id])
      haml :page
    end

    get '/admin/page' do
      pages = Page.all
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/home', :locals => { :pages => pages }
      end
    end

    get '/admin/page/new' do
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/new'
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

    get '/admin/page/edit' do
        haml :'admin/page/edit'
    end

    get '/admin/article/delete' do
        haml :'admin/page/delete'
    end

end
