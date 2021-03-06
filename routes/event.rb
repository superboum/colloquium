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
      soldout = !(event.spots_number_limit ==0 || event.spots_number_limit > event.users_events.count)
      haml :event, :locals => { :event => event,:registration => event.registration ,:isAuthentificated => authenticated?, :isRegistered => isRegistered,soldout: soldout}
    end

    # USERSIDE
    app.get '/profile/event/?' do
      restrictToAuthenticated!
      events_registered = user.events
      other_events = Event.where(registration: true) - events_registered

      haml :'profile/layout', :locals => { :menu =>  2 }, :layout => :'layout'  do
        haml :'profile/event',:locals => { :events_registered => events_registered, other_events: other_events}
      end
    end

    app.get '/profile/event/register/:id/?' do 
      restrictToAuthenticated!
      event = Event.find_by_id(params[:id])

      if(event.form_elements.count == 0)
        event.register_user(user,{})
        redirect "/profile/event", 303
      end
      if !(event.spots_number_limit ==0 || event.spots_number_limit > event.users_events.count)
        redirect "/profile/event"
      end
      felts = event.form_elements

      haml :eventRegistration, :locals => {:event => event,:felts => felts, edit: false, fanswers: {}}
    end

    app.post '/profile/event/register/:id/?' do
      restrictToAuthenticated!

      if :id != params["event"] then 
        puts "error" #@TODO 
      end
      event = Event.find_by_id(params[:id])
      if !(event.spots_number_limit ==0 || event.spots_number_limit > event.users_events.count)
        redirect "/event/#{params[:id]}"
      end
      event.register_user(user,params)

      redirect "/profile/event", 303

    end

    app.get '/profile/event/edit-registration/:id/?' do 
      restrictToAuthenticated!
      event = Event.find_by_id(params[:id])

      haml :eventRegistration, :locals => {:event => event, edit: true}
    end

    app.post '/profile/event/edit-registration/:id/?' do
      restrictToAuthenticated!
      if :id != params["event"] then 
        puts "error" #@TODO 
      end
      event = Event.find_by_id(params[:id])

      event.edit_registration(user,params)

      redirect "/profile/event", 303
    end

    app.get '/profile/event/unregister/:id/?' do 
      restrictToAuthenticated!
      event = Event.find(params[:id])
      event.unregister(user)
      redirect "/profile/event", 303
    end

    #BACKOFFICE
    app.get '/admin/event/?' do
      restrictToAdmin!
      events = Event.order(:created_at)

      haml :'admin/layout', :layout => :'layout'  do
        haml :'admin/event/home', :locals => { :events => events }
      end
    end

    app.get '/admin/event/new/?' do
      restrictToAdmin!
      event = Event.new
      # now will be set to the next plain hour from now (eg 3:23 -> 4:00)
      now = (Time.now+ 60*60 - Time.now.min*60 - Time.now.sec)
      event.start_date = now
      event.end_date = now + 60*60
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/event/newedit', :locals => { :event => event, :edit => false, :unvalid =>false  }
      end
    end

    app.post '/admin/event/new/?' do
      restrictToAdmin!
      event = Event.new
      event.set(params,user)

      if(event.invalid?) 

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
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/event/newedit', :locals => { :event => event, :unvalid => false,:edit => true }
      end

    end

    app.post '/admin/event/edit/:id/?' do
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

    app.post '/admin/event/delete/:id/?' do
      restrictToAdmin!
      Event.destroy(params[:id]) 
      redirect "/admin/event", 303
    end

    app.get '/admin/event/registration/:action/:id/?' do
      restrictToAdmin!
      e= Event.find(params[:id])
      if params[:action] == "enable" && !e.registration
        e.registration = true
      end      
      if params[:action] == "disable" && e.registration
        e.registration = false
      end
      e.save
      redirect '/admin/event'
    end

    app.get '/admin/event/download/?' do
      restrictToAdmin!
      Dir.mkdir('tmp') unless File.exists?('tmp')
      file = Event.make_excel_stats_file 
      send_file file, :filename => 'events.xls', :type => 'Application/octet-stream'
      redirect '/admin/event'
    end

    app.get '/admin/event/:id/?' do 
      restrictToAdmin!
      e = Event.includes(:participants,:form_elements, :form_answers, :users_events).find(params[:id])
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/event/stats', :locals => { :event => e, stats: e.get_stats}
      end
    end 


  end
end
