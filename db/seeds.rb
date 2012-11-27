# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Teacher.create!()
Teacher.create()
User.create!(:email => "admin@gradesnap.com", :hashed_password => "adminatgradesnap", :password => "adminatgradesnap", :password_confirmation => "adminatgradesnap", :teacher_id => 1)
User.create!(:email => "guest@gradesnap.com", :hashed_password => "guest1", :password => "guest1", :password_confirmation => "guest1", :teacher_id => 2)
