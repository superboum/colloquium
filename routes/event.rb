module EventController
  def self.registered(app) # <-- a method yes, but really a hook
    # FRONTOFFICE
    app.get '/event/:id/?' do
      event = Event.find_by_id(params[:id])
      if authenticated?
       isRegistered = user.registered?(event)
     else 
      isRegistered = false
    end
    haml :event, :locals => { :event => event,:registration => event.registration ,:isAuthentificated => authenticated?, :isRegistered => isRegistered}
  end


  app.get '/event/register/:id/?' do 
    restrictToAuthenticated!
    event = Event.find_by_id(params[:id])
    felts = event.form_elements

    haml :eventRegistration, :locals => {:event => event,:felts => felts, edit: false, fanswers: {}}
  end


  app.post '/event/register/:id/?' do
    restrictToAuthenticated!
    if :id != params["event"] then 
        puts "error" #TODO 
      end
      event = Event.find_by_id(params[:id])
      
      user.register_to_event(event,params)

      redirect "/event/#{params[:id]}", 303

    end

 



    # USERSIDE
    app.get '/profile/event/?' do
      restrictToAuthenticated!
      events = user.get_event_registered
      

      haml :'profile/layout', :locals => { :menu => 1 }, :layout => :'layout'  do
        haml :'profile/event',:locals => { :events => events}
      end
    end


   app.get '/profile/event/edit-registration/:id/?' do 
      restrictToAuthenticated!
      event = Event.find_by_id(params[:id])
      
      haml :eventRegistration, :locals => {:event => event, edit: true}
    end


    app.post '/profile/event/edit-registration/:id/?' do
      restrictToAuthenticated!
      if :id != params["event"] then 
        puts "error" #TODO 
      end
      event = Event.find_by_id(params[:id])
      
      user.edit_register_to_event(event,params)

      redirect "/event/#{params[:id]}", 303

    end


    #BACKOFFICE
    app.get '/admin/event/?' do
      restrictToAdmin!
      events = Event.all


      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/event/home', :locals => { :events => events }
      end
    end


    app.get '/admin/event/new/?' do
      restrictToAdmin!
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/event/newedit', :locals => { :event => Event.new, :edit => false, :unvalid =>false  }
      end
    end


    app.post '/admin/event/new/?' do
      restrictToAdmin!
      event = Event.new
      event.set(params,user)

      if(event.invalid?) 

        puts event.errors.messages
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/event/newedit', :locals => { :event => event, :edit => false, :unvalid => true, :errors =>event.errors.messages }
        end
      else
        event.save
        if(params['add_form_element']=='1')   
          redirect "/admin/form_element/new/#{event.id}"
        end
        redirect "/admin/event", 303
      end
    end

    app.get '/admin/event/edit/:id/?' do
      restrictToAdmin!
      event = Event.find(params[:id])
      felts = event.get_felts
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/event/newedit', :locals => { :event => event, :unvalid => false,:edit => true }
      end

    end


    app.post '/admin/event/edit/:id' do
      restrictToAdmin!
      event = Event.find(params[:id])
      event.set(params,user)

      event.save

      event.set_felts(params,user)
      

      if(event.invalid?) 

        puts event.errors.messages
        haml :'admin/layout', :layout => :'layout' do
          haml :'admin/event/newedit', :locals => { :event => event, :edit => true, :unvalid => true, :errors =>event.errors.messages }
        end
      else

        if(params['add_form_element']=='1')   
          redirect "/admin/form_element/new/#{event.id}"
        end
        redirect "/admin/event", 303
      end
    end


    app.get '/admin/event/delete/:id/?' do
      restrictToAdmin!
      event = Event.find(params[:id])
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/event/delete', :locals => { :event => event }
      end
    end

    app.post '/admin/event/delete/:id' do
      restrictToAdmin!
      Event.destroy(params[:id]) 
      redirect "/admin/event", 303
    end

    app.get '/admin/event/registration/:action/:id' do
      e= Event.find(params[:id])
      if params[:action] == "enable" && !e.registration
        e.registration = true
      end      
      if params[:action] == "disable" && e.registration
        e.registration = true
      end
      e.save
      redirect '/admin/event'
    end
  end
end
