require 'sinatra/activerecord'

class Event < ActiveRecord::Base

  has_many :form_answers, :class_name => 'FormAnswer', :foreign_key => 'event_id',:dependent => :delete_all
  has_many :form_elements, :class_name => 'FormElement', :foreign_key => 'event_id',:dependent => :delete_all
  has_many :users_events
  has_many :participants, through: :users_events, source: :user
  belongs_to :admin, :class_name => 'User', :foreign_key => 'admin_id'

	validates :short_text, length: { maximum: 255 ,message: "The size is limited to 255 chars"}
  validates :name, length: {minimum: 1, message: "This field can't be blank"}
  validates :spots_number_limit, numericality: { only_integer: true,greater_than_or_equal_to: 0}

	def get_felts
		return self.form_elements
	end

	def set(params,user)
		self.name = params['name']
    self.short_text = params['short_text']
    self.long_text = params['long_text']
    self.start_date = params['start_date']
    self.end_date = params['end_date']
    self.registration= params['registration']=="1"
    self.spots_number_limit = params["spots_number_limit"]
    self.admin = user

	end

  def get_stats
    nb_of_felts = self.form_elements.count
    ret = Array.new(self.participants.count+1)
    felt_cpt = 2
    felt_key = {}
    ret[0]=Array.new(2+nb_of_felts)
    ret[0][0]="Participant"
    ret[0][1]="Date of </br> registration"
    self.form_elements.each do |felt|
      felt_key[felt.id] = felt_cpt
      ret[0][felt_cpt] = felt.question
      felt_cpt += 1
    end

    participant_key = {}
    ret_cpt = 1
    self.participants.each do |p|
      participant_key[p.id] = ret_cpt
      if  p.last_name.nil?
        p.last_name = ""
      end
      if  p.first_name.nil?
        p.first_name = ""
      end
      ret[ret_cpt]= Array.new(2+nb_of_felts)
      ret[ret_cpt][0]="#{p.last_name.upcase} #{p.first_name.capitalize}"
      date = self.users_events.where(user: p).first.created_at
      date.nil? ? ret[ret_cpt][1] = "Unknown" : ret[ret_cpt][1] = date.strftime("%m/%d/%Y at %I:%M %P")
      ret_cpt +=1
    end

    self.form_answers.each do |fa| 
      ret[participant_key[fa.participant.id]][felt_key[fa.form_element.id]]= fa.answer
    end
  return ret
  end
  

	def set_felts(params,user)
		  
    self.form_elements.each do |felt|
      if(params["delete::"+felt.id.to_s]=='1')
        felt.destroy 
      else  
        felt.question= params['question::'+felt.id.to_s]
        felt.form_type = params["form_type::"+felt.id.to_s]
        felt.event = self
        if felt.form_type == FormElement.TYPES["select"]
          felt.data=params["dataSelect::"+felt.id.to_s]
        end
        felt.save
      end
    end
  end
end
