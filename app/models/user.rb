class User < ApplicationRecord
  validates :email, presence: true, uniqueness: { message: " already exist" }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i , message: "Invalid"}
  has_secure_password

  validates :password, presence: true, length: { minimum: 8 }
  validate :standards

  private

  def standards
    unless password.match?(/\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])/)
      errors.add(:password, "Must include at least one digit, one lowercase, and one uppercase letter")
    end
  end
end
