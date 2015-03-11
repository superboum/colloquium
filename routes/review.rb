class ReviewController < BaseController
  # BACKOFFICE
  get '/admin/review/?' do
    restrictToAdmin!
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/review/home'
    end
  end
end
