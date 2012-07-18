class PreloginsController < ApplicationController


# ensures that the login_required method is run before the hidden and welcome actions.
# Processing of these actions only continues if this filter returns true. The 
# login_required method returns true if session[:user] is set i.e. if the user is 
# logged in. Otherwise it stores the page to return to in the session and redirects 
# to the login page. 

   # Function invoked to sign-up a new user
   def signup
    @user = User.new(params[:user])
    @teacher = Teacher.new(:name => @user.name)
    @user.teacher = @teacher
    if request.post?  
      if @user.save 
        if @teacher.save 
          @user.teacher_id = @teacher.id
          @user.save
          UserMailer.welcome_email(@user).deliver
    	    session[:user] = User.authenticate(@user.email, @user.password)
          #Notifications.welcome_email(@user).deliver
          flash[:notice] = "Signup successful"
          # go to home is sign up success
          redirect_to :action => "dashboard", :controller => 'sessions'   
        end
      end
    else
        flash[:warning] = "Signup unsuccessful"
    end
  end

  # Function invoked to authenticate a user in login 
  #
  # Signup action creates a new user using the parameters it receives. 
  # It it is a post request (the form was submitted) it tries to save the 
  # new user. If the save operation was successful the user is authenticated and 
  # redirected to the welcome screen. If we fail to save the user 
  # (e.g. if validation fails) we add a warning to the flash and the page renders again. 

  def login
    reset_session
    if request.post?
     if session[:user] =  User.authenticate(params[:user][:email], params[:user][:password])
        Rails.logger.info("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
        flash[:message]  = "Login successful"
        #go to dash if log in success
        redirect_to :action => "dashboard", :controller => 'sessions'        
        #redirect_to_stored 
     else
        Rails.logger.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        render "login"
        flash[:warning] = "Login unsuccessful"
      end
    end
  end

  # The forgot password action finds a user using the email address
  # provided as a parameter and the tries to send them a new password. 
  # If successful it redirect them to the login action.
  def forgot_password
    if request.post?
      u = User.find_by_email(params[:user][:email])
      if u
        UserMailer.forgot_password(u).deliver
        redirect_to :action => "index", :controller => 'prelogins'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end

  def home
    render "home"
  end

  def features
	  render "features"
  end

  def legal
	  render "legal"
  end

  def registration
    render 'registration'
  end

  def index
    @user = User.all
    respond_to do |format|
      format.html
    end
  end

end
