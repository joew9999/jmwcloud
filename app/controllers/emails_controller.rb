class EmailsController < AuthenticatedController
  def new
  end

  def create
    RestClient.post "http://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v2/sandboxac47c1ce49cd452ebf12231c279ebb70.mailgun.org/messages",
      :from => "kothmannreunion@yahoo.com",
      :to => "mike.hoffert@gmail.com",
      :subject => "This is subject",
      :text => "Text body",
      :html => "<b>HTML</b> version of the body!"
    flash[:notice] = "Email sent successfully!"
    redirect_to root_path
  end
end
