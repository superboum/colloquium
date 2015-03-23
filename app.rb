#Dependencies
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/config_file'
require 'haml'
require 'pony'

require_relative 'routes/init'

#Initialisations
class ColloquiumApp < Sinatra::Application
  configure do
    @rootFolder = File.dirname(__FILE__)
    register Sinatra::ActiveRecordExtension
    register Sinatra::ConfigFile

    config_file @rootFolder+'/config/general.yml'
    #Database configuration
    set :database_file, @rootFolder+"/config/database.yml"

    #Email configuration
    Pony.options = { 
      :from => 'quentin@deuxfleurs.fr', 
      :via => :smtp, 
      :via_options => { 
        :address                => settings.mail['address'],
        :port                   => settings.mail['port'],
        :user_name              => settings.mail['user_name'],
        :password               => settings.mail['password'],
        :authentication         => settings.mail['authentication'], # :plain, :login, :cram_md5, no auth by default
        :domain                 => settings.mail['domain'], 
        :openssl_verify_mode    => OpenSSL::SSL::VERIFY_NONE,
        :enable_starttls_auto   => settings.mail['starttls']
      } 
    }

    #Cookies configuration
    use Rack::Session::Cookie,
      :key => settings.cookies['key'],
      :path => settings.cookies['path'],
      :secret => settings.cookies['secret']

    register MainController
    register ArticleController
    register EventController
    register FormElementController
    register PageController
    register ReviewController
    register UserController
    register SettingsController
  end
end

require_relative 'helpers/init'
require_relative 'models/init'
