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

    get '/admin' do
        haml :admin
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
