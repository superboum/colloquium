class BaseController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views") }
  
  register Sinatra::ActiveRecordExtension
  
  helpers do
    def pages
      Page.all
    end
  end
end
