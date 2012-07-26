class UserMailer < ActionMailer::Base
  default :from => "contact@gradesnap.com"
 
  def welcome_email(user)
    @user = user
<<<<<<< HEAD
    @url  = "//gradesnap.com/login"
    mail(:to => user.email, :subject => "Welcome to Gradesnap")
=======
    @url  = "http://gradesnap.com/prelogins/#{@user.id}/code"
    mail(:to => @user.email, :subject => "Welcome to Gradesnap")
>>>>>>> d2797aedb39010a4617084ce06854acf361635d0
  end

  def forgot_password(user)
	@user = user
	@newpass = user.new_password
    @url  = "//gradesnap.com/login"
    mail(:to => user.email, :subject => "Forgotten Password for Gradesnap")
  end

  def receive(email)
    page = Page.find_by_address(email.to.first)
    page.emails.create(
      :subject => email.subject,
      :body => email.body
    )
 
    if email.has_attachments?
      email.attachments.each do |attachment|
        page.attachments.create({
          :file => attachment,
          :description => email.subject
        })
      end
    end
  end
  
end
