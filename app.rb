require 'sinatra'
require 'haml'
require 'sinatra/activerecord'
require_relative 'models/init'

class ColloquiumApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :database, {adapter: "sqlite3", database: "app.db"}

    get '/' do
        articles = Article.all
        haml :home, :locals => { :articles => articles }
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

end
