module PageController
  def self.registered(app) # <-- a method yes, but really a hook
    # FRONTOFFICE
    app.get '/page/:task/?' do
      page = Page.find_by_slug(params[:task])
      haml :page, :locals => { :page => page } 
    end

    # BACKOFFICE
    app.get '/admin/page/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/home'
      end
    end

    app.get '/admin/page/new/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/newedit', :locals => { :page => Page.new, :edit => false }
      end
    end

    app.post '/admin/page/new/?' do
      restrictToAdmin!
      page = Page.new
      page.from_params params
      page.author_id = session[:user]
      page.save
      redirect "/admin/page", 303
    end


    app.get '/admin/page/edit/:id/?' do
      restrictToAdmin!
      page = Page.find(params[:id])
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/newedit', :locals => { :page => page, :edit => true }
      end
    end

    app.post '/admin/page/edit/:id/?' do
      restrictToAdmin!
      page = Page.find_by_id(params[:id])
      page.from_params params
      page.author_id = session[:user]
      page.save
      redirect "/admin/page", 303
    end

    app.get '/admin/page/delete/:id/?' do
      restrictToAdmin!
      page = Page.find(params[:id])
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/page/delete', :locals => { :page => page }
      end
    end

    app.post '/admin/page/delete/:id/?' do
      restrictToAdmin!
      Page.destroy(params[:id])
      redirect "/admin/page", 303
    end
  end
end

