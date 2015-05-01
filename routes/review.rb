module ReviewController
  def self.registered(app) # <-- a method yes, but really a hook
    app.get '/profile/review/?' do
      restrictToAuthenticated!
      review = Review.find_by_lecturer_id(session[:user])
                  
      if !review.nil?
        reviewProps = Reviewproposition.where(review_id: review.id)
      end
      
      haml :'profile/layout', :locals => { :menu => 2 }, :layout => :'layout'  do
        haml :'profile/review', :locals => {:review => review, :reviewProps => reviewProps}
      end
    end
    
    app.post "/profile/review" do
      restrictToAuthenticated!
      u = User.find_by_id(session[:user])
      if File.exists?("uploads/") == false
        Dir::mkdir("uploads/", 0777)
      end

      if !params['review'].nil?
        if File.extname(params['review'][:filename]).downcase == ".pdf"
          file = params['review'][:tempfile].read
          md5 = Digest::MD5.hexdigest(file + Time.now.to_s)
          File.write("uploads/" + md5, file)

          if params['action'] == '1st_review' then
            review = Review.new
            review.lecturer_id = u.id
            review.name = params['Name']
            review.general_info = params['general_info']
            review.save
          end
          reviewprop = Reviewproposition.new
          review = Review.find_by_lecturer_id(u.id)
          review.state = "waiting_for_review"
          reviewprop.review_id = review.id
          reviewprop.file = md5
          reviewprop.file_name = params['review'][:filename]
          reviewprop.lecturer_info = params['lecturer_info']
          reviewprop.validator_comment = "Validation in progress"
          reviewprop.save
          review.save
          u.confirm_review(review.name)

          redirect "profile/review", 303
        else #If file extnam != ".pdf"
          haml :'profile/layout', :locals => { :menu => 2 }, :layout => :'layout'  do
            haml :'wrong_extension'
          end
        end
      else #If !params['review'].nil?
        haml :'profile/layout', :locals => { :menu => 2 }, :layout => :'layout'  do
          haml :'wrong_extension'
        end
      end
    end

    # BACKOFFICE
    app.get '/admin/review/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/review/home'
      end
    end
    
    app.get '/admin/review/view/:id' do
      restrictToAdmin!
      review = Review.find_by_id(params[:id])
      
      if review.nil?
        halt 404, haml(:error, :locals => { :code => 404, :msg => "Unable to find a review with this id "+params[:id]})
      end
   
      reviewProps = Reviewproposition.where("review_id = ?", params[:id]) # PB ICI !!!!!!!!!! Donne que les props de la 1ere review
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/review/view', :locals => {:review => review, :reviewProps => reviewProps}
      end
    end

    app.get '/moderation/review/document/:hash/:name' do
      restrictToModerator!
      content_type "application/pdf"
      send_file 'uploads/'+params[:hash]
    end
    
    app.get '/admin/review/assignement/:id' do
      restrictToAdmin!
      reviewProp = Reviewproposition.find_by_id(params[:id])
      review = Review.find_by_id(reviewProp.review_id)
      users = User.where("role >= '1'")
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/review/assignement', :locals => {:reviewProp => reviewProp, :review => review, :users => users}
      end
    end

    app.post '/admin/review/assignement/:id' do
      restrictToAdmin!
      reviewProp = Reviewproposition.find(params[:id])
      review = Review.find(reviewProp.review_id)
      if params['action'] == 'end' then
        review.validator = nil
      else
        id = params['action'].to_i
        if review.lecturer_id  != id
          review.validator_id = id
          User.find_by_id(id).moderation_assign(review.name)
        end
      end
      review.save
      redirect "admin/review/assignement/#{params[:id]}", 303
    end


    app.get '/admin/review/validation/:id' do
      restrictToAdmin!
      reviewProp = Reviewproposition.find_by_id(params[:id])
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/review/validation', :locals => {:reviewProp => reviewProp}
      end
    end
    
    app.post '/admin/review/validation/:id' do
      restrictToAdmin!
      reviewProp = Reviewproposition.find(params[:id])
      reviewProp.validator_comment = params['validator_comment']
      review = Review.find_by_id(reviewProp.review_id)
      review.validator_id = session[:user]
      if params[:validate] == "Valid"
        review.state = "validated"
      elsif params[:validate] == "Ref"
        review.state = "closed"
      else
        review.state = "waiting_for_proposition"
      end
      review.save
      reviewProp.save
      redirect "admin/review/", 303
    end
    

    app.get '/moderation/?' do
      restrictToModerator!
      specific_reviews = Review.where("validator_id = ?", session[:user])# PB ICI !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Donne rien
      haml :'moderation/layout', :layout => :'layout'  do
        haml :'moderation/home', :locals => {:specific_reviews => specific_reviews}
      end
    end

    app.get '/moderation/view/:id' do
      restrictToModerator!
      review = Review.find_by_id(params[:id])

      reviewProps = []      
      if !review.nil?
        reviewProps = Reviewproposition.where(review_id: review.id)
      end
      haml :'moderation/layout', :layout => :'layout'  do
        haml :'moderation/view', :locals => {:review => review, :reviewProps => reviewProps}
      end
    end

    app.get '/moderation/validation/:id' do
      restrictToModerator!
      reviewProp = Reviewproposition.find_by_id(params[:id])
      haml :'moderation/layout', :layout => :'layout'  do
        haml :'moderation/validation', :locals => {:reviewProp => reviewProp}
      end
    end
    
    app.post '/moderation/validation/:id' do
      restrictToModerator!
      reviewProp = Reviewproposition.find(params[:id])
      reviewProp.validator_comment = params['validator_comment']
      review = Review.find_by_id(reviewProp.review_id)
      review.validator_id = session[:user]
      if params[:validate] == "Valid"
        review.state = "validated"
      elsif params[:validate] == "Ref"
        review.state = "closed"
      else
        review.state = "waiting_for_proposition"
      end
      review.save
      reviewProp.save
      redirect "moderation", 303
    end


  end
end
