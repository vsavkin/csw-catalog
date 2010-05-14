class User < ActiveRecord::Base
  has_many :metadatas, :dependent => :delete_all, :autosave => true

  validates_presence_of :name, :password, :email, :login
  validates_uniqueness_of :login
  validates_length_of :password,
                      :minimum => 5,
                      :message => "should be at least 5 characters long"

  before_save :cipher_password!

  def self.cipher=(cipher)
    @@cipher = cipher  
  end

  def self.cipher
    @@cipher ||= MD5Cipher.new
  end

  def self.login(login, password)
    self.find_by_login_and_password(login, cipher.process(password))
  end

  def cipher_password!
    write_attribute("password", User.cipher.process(password))
  end
end
