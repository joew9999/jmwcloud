class EmailsController < AuthenticatedController
  def new
  end

  def create
    RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}@api.mailgun.net/v2/#{ENV['MAILGUN_DOMAIN']}/messages",
      :from => "no-reply@mikehoffert.com",
      :to => params[:email_address],
      :subject => "This is subject",
      :text => "Text body",
      :html => "<b>HTML</b> version of the body!"
    flash[:notice] = "Email sent successfully!"
    redirect_to root_path
  end
end
