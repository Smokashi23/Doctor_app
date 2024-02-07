class User < ApplicationRecord
  validates :email, presence: true, uniqueness: { message: " already exist" }
  has_secure_password
end
