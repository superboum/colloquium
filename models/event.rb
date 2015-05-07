require 'sinatra/activerecord'

class Event < ActiveRecord::Base

  has_many :form_answers, :class_name => 'FormAnswer', :foreign_key => 'event_id',:dependent => :delete_all
  has_many :form_elements, :class_name => 'FormElement', :foreign_key => 'event_id',:dependent => :delete_all
  has_many :users_events,:dependent => :delete_all
  has_many :participants, through: :users_events, source: :user
  belongs_to :admin, :class_name => 'User', :foreign_key => 'admin_id'

  validates :short_text, length: { maximum: 255 ,message: "The size is limited to 255 chars"}
  validates :name, length: {minimum: 1, message: "This field can't be blank"}
  validates :spots_number_limit, numericality: { only_integer: true,greater_than_or_equal_to: 0}

 
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

  def unregister(user)
    ActiveRecord::Base.transaction do
      self.form_answers.destroy(FormAnswer.where(event: self, participant: user))
      self.save
      user.events.destroy(self)
    end
  end

  def set_felts(params,user)
    
    self.form_elements.each do |felt|
      if(params["delete::"+felt.id.to_s]=='1')
        felt.destroy 
      else  
        felt.set_params_with_id(params,self)
        felt.save
      end
    end
  end


  def self.make_excel_stats_file 
    book =  Spreadsheet::Workbook.new
    Event.all.each do |e|
      if e.registration
        e.set_sheet(book)
      end
    end

    file= './tmp/events.xls'
    book.write file

    return file
  end 

  def set_sheet(book)
    stats  = self.get_stats
    stats.unshift([self.name])
    sheet = book.create_worksheet :name => self.name
    for i in 1..(stats.count) # (stats.count -1) doesn't work ?? 
      sheet.row(i-1).replace stats[i-1]
    end
  end

  def get_stats
    stats = Stats.new(self)
    
    return stats.fil(self)
  end 



  def register_user(user,params)
    ActiveRecord::Base.transaction do
      form_elements.each do |felt|
        felt.answer(params,user)
      end

      user.events << self
      user.save
    end
  end

  def edit_registration(user,params)
    ActiveRecord::Base.transaction do

      form_elements.each do |felt|
        felt.edit_answer(params,user)
      end
    end
  end
end
