require 'sinatra'
require 'haml'
require 'sinatra/activerecord'
require_relative 'models/init'

class ColloquiumApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :database, {adapter: "sqlite3", database: "app.db"}

    get '/' do
        haml :home
    end

    get '/admin' do
        haml :admin
    end

    get '/api/article' do
         content_type :json
         articles = Article.all
         if articles
             articles.to_json
         else
             halt 404
         end
    end

    post '/api/article' do
        content_type :json
        param = JSON.parse(request.body.read)
        article = Article.new
        article.title = param["title"]
        article.category = param["category"]
        article.short_text = param["short_text"]
        article.long_text = param["long_text"]
        article.save
    end
end
