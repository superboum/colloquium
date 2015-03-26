require 'sinatra/activerecord'

class User < ActiveRecord::Base
  def registered?(event)
    l= (User.find_by_sql ['SELECT u.* FROM users AS u,
      registered_users_to_events AS r
      WHERE u.id = ? AND 
      r.user_id = u.id AND
      r.event_id = ?',self.id,event.id])
    .length 
    return l>= 1 
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
      fa.form_elements_id = felt.id
      fa.event_id=event.id
      id="felt::#{felt.id}"
      case felt.form_type
      when FormElement.TYPES["bool"]
        if(params[id]=="1")
          fa.answer="true"
        else fa.answer = "false"
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

        ufa = UsersFormAnswer.new
        ufa.form_answers_id = fa.id
        ufa.users_id = self.id
        ufa.save

      end


      participant = RegisteredUsersToEvents.new
      participant.event_id = event.id
      participant.user_id = self.id

      participant.save
    end

    def get_event_registered
      puts "======="
      return Event.joins('LEFT OUTER JOIN registered_users_to_events ON registered_users_to_events.event_id = events.id').where("registered_users_to_events.user_id" => self.id)
    end

    def get_felt_registered
      return FormElement.find_by_sql(['SELECT "form_elements".* FROM "form_elements", form_answers,users_form_answers ON form_answers.form_elements_id = form_elements.id AND users_form_answers.form_answers_id = form_answers.id  WHERE users_form_answers.users_id = ?  ORDER BY form_elements.event_id',self.id])
    end 

    def get_form_answer_registered
      return FormAnswer.joins('LEFT OUTER JOIN users_form_answers ON users_form_answers.form_answers_id = form_answers.id').where( 'users_form_answers.users_id' => self.id).order('form_answers.event_id')
    end

  end

