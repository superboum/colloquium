module Stuff
  def pages ; Page.all ; end
  def reviews ; Review.all ; end

  def mail(destination,subject,content)
    Pony.mail(:to => destination, :from => settings.mail['from'], :subject => subject, :body => content)
  end

  def self.is_blank(hash_or_array)
		return hash_or_array.all? &:blank?
	end
end
