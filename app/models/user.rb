class User < ActiveRecord::Base

  has_many :projects
  has_many :tasks

  validates :name, presence: true
  validates :email, presence: true

  has_secure_password

end
