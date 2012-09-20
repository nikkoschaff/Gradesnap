# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.create!(:name => "Gradesnap Monthly (4.99/month)", :price => 4.99)
Plan.create!(:name => "Gradesnap Yearly (49.99/year)", :price => 49.99)
User.create!(:name => "Admin", :email => "admin@gradesnap.com", :hashed_password => "adminatgradesnap", :password => "adminatgradesnap", :plan_id => 1, :password_confirmation => "adminatgradesnap")
User.create!(:name => "Guest", :email => "guest@gradesnap.com", :hashed_password => "guest1", :password => "guest1", :password_confirmation => "guest1", :plan_id => 1, :teacher_id => 1)
