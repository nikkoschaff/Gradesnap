class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name, :subject
	validates :email, :presence => true
end
