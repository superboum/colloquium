require 'sinatra/activerecord'

class User < ActiveRecord::Base

  has_many :reviews, :class_name => 'Review', :foreign_key => 'lecturer_id'
  has_many :reviews_to_correct, :class_name => 'Review', :foreign_key => 'validator_id'
  has_many :users_events
  has_many :events, through: :users_events


  def registered?(event)
   return self.events.include?(event)
 end

 def raw_password(rpass)
  self.password = Digest::SHA256.hexdigest(rpass)
end

def correct_password?(rpass)
  self.password == Digest::SHA256.hexdigest(rpass)
end

def generate_token() 
 self.token = "%010x" % rand(10000000000)
end

def create_account(email, rpass)
  self.raw_password(rpass)
  self.email = email
  self.generate_token
  self.role = -1
  Pony.mail(:to => self.email, 
   :subject => '[Colloquium] Please confirm your email', 
   :body => "Hi !\nYou just registered an account on Colloquium.\nPlease confirm your email address by clicking or copy-pasting this link : "+self.confirmation_link())
end

def lost_password()
 self.generate_token 
 Pony.mail(:to => self.email, 
   :subject => '[Colloquium] Reset your password', 
   :body => "Hi !\nIt seems you have lost your password.\nYou can reset it by clicking or copy-pasting this link : "+self.password_lost_link())
end

def confirmation_link()
 URI.escape(ColloquiumApp.settings.parameters['base_url'] + '/confirm/'+self.email+'/'+self.token)
end

def password_lost_link()
 URI.escape(ColloquiumApp.settings.parameters['base_url'] + '/profile/password_change/'+self.email+'/'+self.token)
end

def check_token(token)
 puts self.token
 puts token
 if self.token == token then
   self.token = nil
   return true
 end
 return false
end


def register_to_event(event,params)
  felts = event.get_felts


  felts.each do |felt|
    fa = FormAnswer.new
    fa.form_element = felt
    fa.event = event
    fa.participant = self


    id="felt::#{felt.id}"
    case felt.form_type
    when FormElement.TYPES["bool"]
      fa.answer=(params[id]=="1")
    when FormElement.TYPES["select"]
      fa.answer =params[id]      
    when FormElement.TYPES["string"]
      fa.answer = params[id]
    else
        #TODO
        puts "\033[31merror\033[0m"
      end
      fa.save
      
    end
    
    event.number_of_participants += 1
    event.save

    self.events << event
    self.save


    
  end

  

  def edit_register_to_event(event,params)
  	felts = event.get_felts


  	felts.each do |felt|
      fa=FormAnswer.where(form_element: felt, participant: self).first
      newFormAnswer = (fa==nil)
      if(newFormAnswer)
        p "New FormAnswer creation"
        fa=FormAnswer.new
        fa.form_element = felt
        fa.event=event
      end
      id="felt::#{felt.id}"
      case felt.form_type
      when FormElement.TYPES["bool"]
       if(params[id]=="1")
         fa.answer="true"
       else 
        fa.answer = "false"
       end
     when FormElement.TYPES["select"]
       fa.answer =params[id]      
     when FormElement.TYPES["string"]
       fa.answer = params[id]
     else
    #TODO
    puts "\033[31merror\033[0m"
  end
  fa.save

end

end

def get_event_registered
 return self.events
end

def get_felt_registered

 return self.events.felts
end 



 def get_form_answer_registered(*event)
  if(event.empty?)
   return FormAnswer.where(user: self).order(:event_id)
 else 
   return FormAnswer.where(user: self,event: event).order(:event_id)
 end

end


end

