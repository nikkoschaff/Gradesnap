# The view used to create the email is stored in 
# app/views/notifications/forgot_password.rhtml

class Notifications < ActionMailer::Base

  default :from => "support@gradesnap.com"

  def forgot_password(to, login, pass, sent_at = Time.now)
    @subject    = "Your password is ..."
    @body['login']=email
    @body['pass']=pass
    @recipients = to
    @from       = 'support@gradesnap.com'
    @sent_on    = sent_at
    @headers    = {}
  end

  def deliver_forgot_password(email, newpass)
    #@user = session[:user]
    @url = "http://gradesnap.com"
    @newpass = newpass
    mail(:to => email, :subject => "Forgotten password for Gradesnap")
  end

  def welcome_email(user)
    @user = user
    @url  = "http://gradesnap.com/login"
    mail(:to => user.email, :subject => "Welcome to Gradesnap!")
  end
  
end
