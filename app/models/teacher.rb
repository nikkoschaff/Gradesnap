class Teacher < ActiveRecord::Base
  has_one :user
  has_many :courses, :dependent => :destroy
end
