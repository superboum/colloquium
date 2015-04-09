module ReviewController
  def self.registered(app) # <-- a method yes, but really a hook
    app.get '/profile/review/?' do
      restrictToAuthenticated!
      review = Review.find_by_lecturer_id(session[:user])
                  
      if !review.nil?
        reviewProps = Reviewproposition.where(review_id: review.id)
        end
      end
      
      haml :'profile/layout', :locals => { :menu => 2 }, :layout => :'layout'  do
        haml :'profile/review', :locals => {:review => review, :reviewProps => reviewProps}
      end
    end
    
    app.post "/profile/review" do
      restrictToAuthenticated!
      uId = session[:user]
      u = User.find_by_id uId
      if File.exists?("uploads/") == false
        Dir::mkdir("uploads/", 0777)
      end
      if File.extname(params['review'][:filename]).downcase == ".pdf"
        md5 = Digest::MD5.hexdigest(params['review'][:tempfile].read)
        File.open("uploads/" + md5, "w") do |f|
          f.write(params['review'][:tempfile].read)
        end
        
        
        if params['action'] == '1st_review' then
          review = Review.new
          review.lecturer_id = uId
          review.name = params['Name']
          review.general_info = params['general_info']
          review.save
        end
        reviewprop = Reviewproposition.new
        review = Review.find_by_lecturer_id(uId)
        review.state = "waiting_for_validation"
        reviewprop.review_id = review.id
        reviewprop.file = md5
        reviewprop.file_name = params['review'][:filename]
        reviewprop.lecturer_info = params['lecturer_info']
        reviewprop.validator_comment = "Validation in progress"
        reviewprop.save
        review.save
        redirect "profile/review", 303
      else #If file extnam != ".pdf"
        haml :'no'
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
      review = Review.find_by(params[:id])

      reviewProps = []      
      if !review.nil?
        reviewProps = Reviewproposition.where(review_id: review.id)
      end
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/review/view', :locals => {:review => review, :reviewProps => reviewProps}
      end
    end
    
    app.get '/admin/review/view/uploads/Jean-Chorin_2/billet_pot_commun.pdf' do
      pdf :'uploads/Jean-Chorin_2/billet_pot_commun.pdf'
    end
    
    app.get '/admin/review/validation/:id' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/review/validation'
      end
    end
    
    app.post '/admin/review/validation/:id' do
      restrictToAdmin!
      reviewProp = Reviewproposition.find(params[:id])
      reviewProp.validator_comment = params['validator_comment']
      #reviewProp.save
      review = Review.find_by reviewProp.review_id
      review.validator_id = session[:user]
      if params[:validate] == "Valid"
        review.state = "validated"
        review.save
      else
        review.state = "waiting_for_review"      
        review.save
      end
      reviewProp.save
      redirect "admin/review/", 303
    end
    
  end
end
