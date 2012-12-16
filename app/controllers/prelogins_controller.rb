require 'mail'
class PreloginsController < ApplicationController
# ensures that the login_required method is run before the hidden and welcome actions.
# Processing of these actions only continues if this filter returns true. The 
# login_required method returns true if session[:user] is set i.e. if the user is 
# logged in. Otherwise it stores the page to return to in the session and redirects 
# to the login page. 


  # Signup action creates a new user using the parameters it receives. 
  # It is a post request (the form was submitted) it tries to save the 
  # new user. If the save operation was successful the user is authenticated and 
  # redirected to the welcome screen. If we fail to save the user 
  # (e.g. if validation fails) we add a warning to the flash and the page renders again. 

  def login
    reset_session
    if request.post?
     if session[:user] =  User.authenticate(params[:user][:email], params[:user][:password])
        redirect_to :action => "dashboard", :controller => 'sessions'        
      end
    end
  end

  # The forgot password action finds a user using the email address
  # provided as a parameter and the tries to send them a new password. 
  # If successful it redirect them to the login action.
  def forgot_password
    if request.post?
      @user = User.find_by_email(params[:user][:email])
      if @user
        UserMailer.forgot_password(@user).deliver
        redirect_to :action => "index", :controller => 'prelogins'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end

  # MAILER FUNCTION:
  # THIS SHIT BREAKS IF THE MAILERS BREAK IF THE SSL CERT BREAKS
  def confirmed_it
    #look up user
    url = request.fullpath
    id = url[9]
    u = User.find(:id => user_id)
    # check code to paramater code
    if u.confirmation_code == confirmation_code then
      u.confirmed = true
      u.save
      #if all clear log them in and go to dashboard
      session[:user] = User.authenticate(u.email, u.password)
      redirect_to :action => "dashboard", :controller => 'sessions'   
    end
    redirect_to :action => "signup", :controller => 'prelogins'   
  end

  # MAILER FUNCTION:
  # generates a confirmation code 
  def random_code(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newcode = ""
    1.upto(len) { |i| newcode << chars[rand(chars.size-1)] }
    return newcode
  end
end
