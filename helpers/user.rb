module UserHelper
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

    def logUser(email,password)
        user = User.find_by email: email
        ok = (user.instance_of? User and user.correct_password?(password))
        if ok then
            puts "Successfully logged " + user.email
            session[:user] = user.id
        else
            puts "Unable to log " + email
        end
        ok
    end

    # Used to check role
    def admin? ; user != nil and user.role >= 2 ; end
    def moderator? ; user != nil and user.role >= 1 ; end
    def authenticated? ; user != nil and user.role >= 0 ; end
    def notAuthenticated? ; user == nil ; end

    # Used to restrict access
    def restrictToAdmin! ; redirect to('/login'),303 unless admin? ; end
    def restrictToModerator! ; redirect to('/login'),303 unless moderator? ; end
    def restrictToAuthenticated! ; redirect to('/login'),303 unless authenticated? ; end
    def restrictToNotAuthenticated! ; redirect to('/account'),303 unless notAuthenticated? ; end
end
