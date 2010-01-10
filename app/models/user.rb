class User < ActiveRecord::Base
  has_many :metadatas, :dependent => :delete_all, :autosave => true
  
  validates_presence_of :name, :password, :email, :login
  validates_uniqueness_of :login
  validates_length_of :password,
                      :minimum => 5,
                      :message => "should be at least 5 characters long"
end
