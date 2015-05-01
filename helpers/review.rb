module ReviewHelper

  def validation_review(params)
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
  end

end