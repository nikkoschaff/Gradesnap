class Teacher < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_one :user
  has_many :courses, :dependent => :destroy
end
