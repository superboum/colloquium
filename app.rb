require 'sinatra'
require 'haml'
require "sinatra/activerecord"

class ColloquiumApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    set :database, {adapter: "sqlite3", database: "app.db"}

    get '/' do
        haml :home
    end

    get '/admin' do
        haml :admin
    end
end
