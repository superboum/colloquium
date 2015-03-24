module FormElementController
  def self.registered(app) # <-- a method yes, but really a hook
    # ELEMENT FORM #

    app.get '/admin/form_element/new/?' do
      restrictToAdmin!
      events = Event.order(:name)
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/formElement/eventChoice', :locals => {:events => events}
      end
    end

    app.post '/admin/form_element/new' do
      restrictToAdmin!
      id=params[:id]
      redirect "/admin/form_element/new/#{id}"
    end

    app.get '/admin/form_element/new/:id/?' do
      restrictToAdmin!
      felt = FormElement.new
      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/formElement/newedit', :locals => {:felt => felt,:event => Event.find(params[:id]),:elements=> FormElement.TYPES, :edit => false}
      end

    end

    app.post '/admin/form_element/new/:id' do 
      restrictToAdmin!
      if :id != params["event"] then 
        puts "error" #TODO 
      end


      felt = FormElement.new
      felt.question = params["question"]
      felt.form_type = params["form_type"]
      felt.event_id = params["event"]
      if felt.form_type == FormElement.TYPES["select"]
        felt.data=params["dataSelect"]
      end
      felt.save

      if(params['add_form_element']=='1')   
        redirect "/admin/form_element/new/#{params["event"]}"
      end
      redirect "/admin/event", 303

    end

    app.get '/admin/formElement/selectContent/:id/?' do
      restrictToAdmin!
      felt= FormElement.find (params[:id])


      haml :'admin/layout', :layout => :'layout' do
        haml :'admin/formElement/selectContent', :locals => {:felt=> felt}
      end
    end

    app.post '/admin/formElement/selectContent/:id' do
      restrictToAdmin!
      if(params[:id] != params["felt"]) 
        then puts "error"
      end

      felt= Form.find(params["felt"])
      felt.data=params["data"]
      felt.save
    end     
  end
end
