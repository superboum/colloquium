class EventController < BaseController
  # FRONTOFFICE
  get '/event/:id' do
    event = Event.find_by_id(params[:id])
    haml :event, :locals => { :event => event }
  end

  #BACKOFFICE
  get '/admin/event' do
    events = Event.all
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/event/home', :locals => { :events => events }
    end
  end
  get '/admin/event/new' do
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/event/newedit', :locals => { :event => Event.new, :edit => false }
    end
  end

  post '/admin/event/new' do
    event = Event.new
    event.title = params['title']
    event.short_text = params['short_text']
    event.begin = params['begin']
    event.end = params['end']
    event.save
    redirect "/admin/event", 303
  end


  get '/admin/event/edit/:id' do
    event = Event.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/event/newedit', :locals => { :event => event, :edit => true }
    end

  end


  post '/admin/event/edit/:id' do
    event = Event.find(params[:id])
    event.title = params['title']
    event.short_text = params['short_text']
    event.begin = params['begin']
    event.end = params['end']
    event.save
    redirect "/admin/event", 303
  end

  get '/admin/event/delete/:id' do
    event = Event.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/event/delete', :locals => { :event => event }
    end
  end

  post '/admin/event/delete/:id' do
    Event.destroy(params[:id])
    redirect "/admin/event", 303
  end

end
