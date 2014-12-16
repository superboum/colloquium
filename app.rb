require 'sinatra'
require 'haml'

class ColloquiumApp < Sinatra::Base
    get '/' do
        haml :home
    end

    get '/admin' do
        haml :admin
    end
end
