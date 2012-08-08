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
       if validate_recap(params, @user.errors) #captcha line
         if @user.save 
           if @teacher.save
             @user.teacher_id = @teacher.id
             @user.save
             # MAILER FUNCTIONS THIS SHIT BREAKS IF THE MAILERS BREAK IF THE SSL CERT BREAKS
             #UserMailer.welcome_email(@user).deliver
             flash[:notice] = "Signup successful"
             # go to home is sign up success
             session[:user] = User.authenticate(@user.email, @user.password)
             redirect_to :action => "eula", :controller => 'prelogins'
             #redirect_to :action => "confirm_it", :controller => 'prelogins' 
           end
         end
       end
     else
       flash[:warning] = "Signup unsuccessful"
     end
   end

  # Function invoked to authenticate a user in login 
  #
  # Signup action creates a new user using the parameters it receives. 
  # It is a post request (the form was submitted) it tries to save the 
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
        respond_to do |format|
          format.html
        end
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

  #Nikko pls
  def home
    respond_to do |format|
      format.html
    end
  end

  #Nikko pls
  def features
    respond_to do |format|
      format.html
    end 
  end

  #Nikko pls
  def legal
    respond_to do |format|
      format.html
    end  
  end

  #Nikko pls
  def registration
    respond_to do |format|
      format.html
    end  
  end

  #Conor pls
  def eula
    respond_to do |format|
      format.html
    end
  end

  #Conor pls
  def thanks
    respond_to do |format|
      format.html
    end
  end
  
  # finds user to set the eula marker to trueeeeeeeeeeee
  def confirm_eula
    @user = User.all.last
    Rails.logger.info("~~~~~~2~~~~~~~~#{@user}")
    if @user != nil
      @user.eula = true
      Rails.logger.info("~~~~~~~3~~~~~~~~#{@user.eula}")
      if @user.save
        Rails.logger.info("~~~~~~~4~~~~~~~~#{@user.eula}")
        redirect_to :action => "dashboard", :controller => "sessions"
      end
    end
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

  def post_contact
    Rails.logger.info("hue========================================hue")
    respond_to do |format|
      format.xml
      redirect_to :action => "thanks", :controller => "prelogins"
    end
  end
end
