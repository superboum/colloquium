#Dependencies
require 'sinatra'
require 'sinatra/activerecord'
require 'haml'

#Submodules
require_relative 'models/init'
require_relative 'routes/init'

class ColloquiumApp < Sinatra::Application
  register Sinatra::ActiveRecordExtension
  enable :sessions

  set :session_secret, 'ThisIsNotSafeAndShouldBeSetInAConfigurationFile...'
  set :database, {adapter: "sqlite3", database: "app.db"}

  use MainController
  use ArticleController
  use PageController
  use EventController
  use ReviewController
  use UserController
  use SettingsController
  use FormElementController 
end
