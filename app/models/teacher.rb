class Teacher < ActiveRecord::Base
  has_one :user, :dependent => :destroy
  has_many :courses, :dependent => :destroy
end
