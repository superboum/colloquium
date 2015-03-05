class PageController < BaseController
  # FRONTOFFICE
  get '/page/:id' do
    page = Page.find(params[:id])
    haml :page, :locals => { :page => page } 
  end

  # BACKOFFICE
  get '/admin/page' do
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/page/home'
    end
  end

  get '/admin/page/new' do
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/page/newedit', :locals => { :page => Page.new, :edit => false }
    end
  end

  post '/admin/page/new' do
    page = Page.new
    page.title = params['title']
    page.category = params['category']
    page.author = params['author']
    page.long_text = params['long_text']
    page.priority = params['priority']
    page.save
    redirect "/admin/page", 303
  end


  get '/admin/page/edit/:id' do
    page = Page.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/page/newedit', :locals => { :page => page, :edit => true }
    end
  end

  post '/admin/page/edit/:id' do
    page = Page.find_by_id(params[:id])
    page.title = params['title']
    page.category = params['category']
    page.author = params['author']
    page.long_text = params['long_text']
    page.priority = params['priority']
    page.save
    redirect "/admin/page", 303
  end

  get '/admin/page/delete/:id' do
    page = Page.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/page/delete', :locals => { :page => page }
    end
  end

  post '/admin/page/delete/:id' do
    Page.destroy(params[:id])
    redirect "/admin/page", 303
  end
end