require 'digest/sha3'

class User < ActiveRecord::Base
  validates_length_of :password, :within => 5..40, :on => 'create'
  validates_presence_of :email, :salt, :message => "No email"
  validates_presence_of :password_confirmation, :password, :on => 'create'
  validates_uniqueness_of :email
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([A@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})z/i, :message => "Invalid email", :multiline => true
  attr_protected :id, :salt
  attr_accessor :password, :password_confirmation, :confirmation_code, :confirmed
  belongs_to :teacher, :foreign_key => "teacher_id"
  attr_writer :teacher
  accepts_nested_attributes_for :teacher

  def self.authenticate(email, pass)
    u=find(:first, :conditions=>["email = ?", email])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
  end  

  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    new_pass
    #Notifications.deliver_forgot_password(self.email, new_pass).deliver
  end

  protected

  def self.encrypt(pass, salt)
    Digest::SHA3.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end
