class UsersController < ApplicationController

  before_filter :admin_required, :only => [:show, :index, :destroy, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @teacher = Teacher.new()
    @user.teacher = @teacher
    if request.post? and validate_recap(params, @user.errors) and @teacher.save
      @user.teacher_id = @teacher.id
      if @user.save

        #: MAILER FUNCTIONS THIS SHIT BREAKS IF THE MAILERS BREAK IF THE SSL CERT BREAKS
        #UserMailer.welcome_email(@user).deliver
        session[:user] = User.authenticate(@user.email, @user.password)
        redirect_to  :action => :dashboard, :controller => :sessions
      else
        redirect_to :users => :new
      end
    else 
      redirect_to :users => :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to :action => :dashboard, :controller => :sessions
    else
      redirect_to :action => :account, :controller => :sessions
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end
end
