class Metadata < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :xml, :standard
end
