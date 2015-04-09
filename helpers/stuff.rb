module Stuff
  def pages ; Page.all ; end
  def reviews ; Review.all ; end

  def mail(destination,subject,content)
    Pony.mail(:to => destination, :from => settings.mail['from'], :subject => subject, :body => content)
  end
end
