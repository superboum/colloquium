class FormElementController < BaseController
    elements={"bool" => FormElement.TYPE_BOOL,"choice" => FormElement.TYPE_CHOICE,"string" => FormElement.TYPE_STRING}

    # ELEMENT FORM #

    get '/admin/form_element/new' do
        events = Event.order(:name)
        haml :'admin/layout', :layout => :'layout' do
            haml :'admin/formElement/eventChoice', :locals => {:events => events}
        end
    end

    post '/admin/form_element/new' do
        id=params[:id]
        redirect "/admin/form_element/new/#{id}"
    end
    
    get '/admin/form_element/new/:id' do
        felt = FormElement.new
        haml :'admin/layout', :layout => :'layout' do
            haml :'admin/formElement/newedit', :locals => {:felt => felt,:event => Event.find(params[:id]),:elements=> elements, :edit => false}
        end

    end

    post '/admin/form_element/new/:id' do 
        felt = FormElement.new
        felt.question = params["question"]
        felt.form_type = params["form_type"]
        if :id != params["event"] then 
            puts "error" #TODO 
        end

        felt.event_id = params["event"]
        felt.save
        if felt.form_type == FormElement.TYPE_CHOICE then 
            redirect '/admin/formElement/selectContent/#{felt.id}'
        end
        
        redirect "/admin/event", 303

    end

    get '/admin/formElement/selectContent/:id' do
        felt= FormElement.find (params[:id])


        haml :'admin/layout', :layout => :'layout' do
            haml :'admin/formElement/selectContent', :locals => {:felt=> felt}
        end
    end

    post '/admin/formElement/selectContent/:id' do
        if(params[:id] != params["felt"]) 
            then puts "error"
        end

        felt= Form.find(params["felt"])
        felt.data=params["data"]
        felt.save
    end     


end