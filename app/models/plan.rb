class Plan < ActiveRecord::Base
  has_many :users
  attr_accessible :name, :price
  validates_uniqueness_of :name

end
