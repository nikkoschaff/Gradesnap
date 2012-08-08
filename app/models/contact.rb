class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name, :subject
end
