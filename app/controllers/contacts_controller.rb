class ContactsController < ApplicationController

  #before_filter :login_required, :only => [:show, :edit, :update, :destroy]

  before_filter :admin_required, :only => [:show, :index, :destroy]
  
  def index
    @contacts = Contact.all
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def create
    @contact = Contact.new(params[:contact])
  	if @contact.save
      redirect_to :action => "thanks", :controller => "prelogins"
    	else
  	  redirect_to :action => "home", :controller => "prelogins" 
  	end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
  end
  
end
