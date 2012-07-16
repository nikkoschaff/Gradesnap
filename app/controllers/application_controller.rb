class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "application"
#before_filter :login_required, :only=>[':scansheets, 
#              :scansheet, 
#              :grademodels,
#              :sessions,
#              :stats']
  # Function returns boolean whether an action necessitates a log in
  #
  # login_required is a filter that allows us to control access to actions. 
  # In the user controller we have three actions, welcome, hidden and 
  # forgot_password that can only be accessed by logged in users. 
  
  def session_cleanup
    backup = session.data.clone
    reset_session
    backup.each { |k, v| session[k] = v unless k.is_a?(String) && k =~ /^as:/ }
  end

  def login_required
    if session[:user]
      return true
    end
    flash[:warning]='Please login to continue'
    #session[:return_to]=request.url
    redirect_to :controller => "prelogins", :action => "login"
    return false 
  end

  # current_user is a convenience method for accessing the currently-logged-in user.
  def current_user
    session[:user]
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  # The redirect_to_stored method is used to redirect to a page stored in
  # the session (It redirects to the url stored in the variable session[:return_to]).
  #def redirect_to_stored
  #  if return_to = session[:return_to]
  #    #session[:return_to]=nil
  #    #redirect_to_url(return_to)
  #    render(return_to)
  # else
  #    #redirect_to :controller=>'user', :action=>'welcome'
  #    render :controller=>'prelogins', :action=>'index'
  #
  #  end
  #end


end
