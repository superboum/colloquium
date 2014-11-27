require 'sinatra'
require 'haml'

get '/' do
    haml :home
end

get '/admin' do
    haml :admin
end

#pages Jean
  #page principale de Jean (page 1)
get '/jean' do
    haml :jean
end

get '/jean1' do
    haml :jean
end

  #page 2
get '/jean2' do
    haml :jean2
end

  #page 3
get '/jean3' do
    haml :jean3
end


get '/navigation' do
    haml :navigation
end

get '/laurent' do
	haml :laurent
end
