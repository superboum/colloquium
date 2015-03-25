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

  def create_account(email, rpass)
    self.raw_password(rpass)
    self.email = email
    self.token = "%010x" % rand(10000000000)
    self.role = -1
    Pony.mail(:to => self.email, 
              :subject => '[Colloquium] Please confirm your email', 
              :body => "Hi !\nYou just registered an account on Colloquium.\nPlease confirm your email address by clicking or copy-pasting this link : "+self.confirmation_link())
  end

  def confirmation_link()
    URI.escape(ColloquiumApp.settings.parameters['base_url'] + '/confirm/'+self.email+'/'+self.token)
  end

  def check_token(token)
    if self.token == token then
      self.token = nil
      self.role = 0
      return true
    end
    return false
  end
end

