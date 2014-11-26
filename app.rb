require 'sinatra'
require 'haml'

get '/' do
    haml :home
end

get '/admin' do
    haml :admin
end

get '/jean' do
    haml :jean
end

get '/navigation' do
    haml :navigation
end

get '/laurent' do
	haml :laurent
end

