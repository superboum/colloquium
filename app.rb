# myapp.rb
require 'sinatra'

class KaigiApp < Sinatra::Base
  get '/' do
    'Hello world!'
  end
end
