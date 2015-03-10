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
    event.name = params['name']
    event.short_text = params['short_text']
    event.start_date = params['start_date']
    event.end_date = params['end_date']
    event.place_number = params['place_number']
    event.registration= params['registration']==1
    event.save
    if(params['add_form_event']='1')
        
    redirect "/admin/form_element/new/#{event.id}"
    end
    redirect "/admin/event", 303
end


  get '/admin/event/edit/:id' do
    event = Event.find(params[:id])
    begin
      felts = FormElement.find_all_by! event_id: params[:id]
    rescue => e
      felts= []
    end


    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/event/newedit', :locals => { :event => event, :felts => felts ,:edit => true }
    end

  end


post '/admin/event/edit/:id' do
    event = Event.find(params[:id])
    event.name = params['name']
    event.short_text = params['short_text']
    event.start_date = params['start_date']
    event.end_date = params['end_date']
    event.registration= params['registration']==1
    event.place_number = params['place_number']
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


