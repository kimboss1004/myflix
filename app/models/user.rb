class User < ActiveRecord::Base
  has_many :reviews
  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true, uniqueness: true
  validates :password, presence: true

end