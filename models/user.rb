require 'sinatra/activerecord'

class User < ActiveRecord::Base

  has_many :reviews, :class_name => 'Review', :foreign_key => 'lecturer_id'
  has_many :form_answers, class_name: 'FormAnswer', foreign_key: 'participant_id'
  has_many :reviews_to_correct, :class_name => 'Review', :foreign_key => 'validator_id'
  has_many :users_events
  has_many :events, through: :users_events
  has_many :pages, :class_name => 'Page', :foreign_key => 'author_id'
  has_many :users_meals
  has_many :meals, through: :users_meals, source: :meal
  

  def full_name
    if  self.last_name.nil?
      self.last_name = ""
    end
    if  self.first_name.nil?
      self.first_name = ""
    end
    return self.last_name.upcase+" "+self.first_name.capitalize
  end

  def registered?(event)
    return self.events.include?(event)
  end

  def raw_password(rpass)
    self.password = Digest::SHA256.hexdigest(self.email + ':' + rpass)
  end

  def correct_password?(rpass)
    self.password == Digest::SHA256.hexdigest(self.email + ':' + rpass)
  end

  def generate_token() 
    self.token = "%010x" % rand(10000000000)
  end

  def create_account(email, rpass)
    self.email = email
    self.raw_password(rpass)
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

  def from_params(params)
    self.first_name = params['first_name']
    self.last_name = params['last_name']
    self.phone = params['phone']
    self.address = params['address']
    self.diet = params['diet']
    self.nationality = params['nationality']
    self.title = params['title']
    self.sex = params['sex']
  end

  def from_params_admin(params)
    self.from_params(params)

    self.role = params['role']
    self.has_paid = params['has_paid']
    self.email = params['email']
    if params['password'] != "" then self.raw_password(params['password']); end

  end

  def edit_register_to_event(event,params)
    felts = event.get_felts

    ActiveRecord::Base.transaction do

      felts.each do |felt|
        felt.edit_answer(params,self)
      end
    end
  end

  def get_form_answer_registered(*event)
    if(event.empty?)
      return FormAnswer.where(user: self).order(:event_id)
    else 
      return FormAnswer.where(user: self,event: event).order(:event_id)
    end
  end

  #Meal

  def get_table_of_meals
   tom = TableOfMeals.new 
   tom.each do |line, meal,meal_exists, store|

      if(meal_exists)
        m = meal.meal
        line<< [m,meal.participants.include?(self)]
      else 
        line << [m,nil]
      end
      
    end
    return tom.table
  end

  def add_undef_meals(meals)
    meals.each do |day,meal_types|
      meal_types.each do |m|
        meal = Meal.where(day: Date.parse(day),meal: m).first

        unless(self.meals.include?(meal))
          self.meals<<meal
        end
      end

    end
  end

  def remove_former_meals(meals)
    self.meals.each do |meal|
      day,m = meal.get_day_and_meal_in_view_format
      unless meals.has_key?(day) && meals[day].has_key?(m)
        self.meals.destroy(meal)
      end
    end
  end


  def register_to_meal(meals)
    ActiveRecord::Base.transaction do
      add_undef_meals(meals)
      remove_former_meals(meals)
    end
  end



  #Review

  def confirm_review(name)
    Pony.mail(:to => self.email, 
              :subject => 'Review ' + name, 
              :body => "Hello\n\n Your submission has been taken in account. Thanks for participating.\n\n This email has been send automaticaly, please do not respond.")
  end

  def moderation_assign
    Pony.mail(:to => self.email, 
              :subject => 'New Review assigned', 
              :body => "You have one new Review to validate.\n\nThis email has been send automaticaly, please do not respond.")
  end

  def review_validation_mail(review)
    if review.state == "waiting_for_proposition"
      body = "Your review has been read by one of our moderator. Please send a new proposition with the asked modification."
    end
    if review.state == "validated"
      body = "Your review has been validated. Welcome to the conference."
    end
    if review.state == "closed"
      body = "Sorry, the review subsmission is closed. Please try next year"
    end
    Pony.mail(:to => self.email, 
              :subject => 'Review ' + review.name + ' checked', 
              :body => body + "\n\nThis email has been send automaticaly, please do not respond.")
  end

end
