
# Formerly known as post-login, session control covers all user-oriented 
# functionality after logging in

class SessionsController < ApplicationController


before_filter :login_required#, :only=>['change_password', 'logout', 'forgot_password', 'dashboard', 'grade', 'stats', 'create']
 
  # Function invoked to logout a user
  def logout 
    session[:user] = nil
    flash[:message] = 'Logged out'
    redirect_to :action => 'index', :controller => 'prelogins'
  end

  def change_password
    @user=session[:user]
    if request.post?
      @user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if @user.save
        flash[:message]="Password Changed"
        redirect_to :action=> 'dashboard', :controller => 'sessions'
      end
    end
  end

  def dashboard
    render "dashboard"
  end

  def myaccount
    render 'account'
  end

  def payment
    render 'payment'
  end
  
end
