class BaseController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views") }
  
  register Sinatra::ActiveRecordExtension
  
  helpers do
    ###
    # Content related
    ###

    # Used to build template
    def pages ; Page.all ; end

    ###
    # USER RELATED
    ###

    # Used to get current user informations
    def user
      if session[:user] != nil then
        if @user == nil then
          @user = User.find session[:user]
        else
          @user
        end
      end
    end

    # Used to check role
    def admin? ; user != nil and user.role >= 2 ; end
    def moderator? ; user != nil and user.role >= 1 ; end
    def authenticated? ; user != nil and user.role >= 0 ; end

    # Used to restrict access
    def restrictToAdmin! ; redirect to('/login'),303 unless admin? ; end
    def restrictToModerator! ; redirect to('/login'),303 unless moderator? ; end
    def restrictToAuthenticated! ; redirect to('/login'),303 unless normal? ; end
  end
end

