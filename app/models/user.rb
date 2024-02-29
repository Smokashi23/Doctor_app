class User < ApplicationRecord
  belongs_to :role
  has_many :appts, dependent: :destroy
  has_many :slots, dependent: :destroy
  validates :email, presence: true, uniqueness: { message: " already exist" }, format: { with: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]+\z/i , message: "Invalid"}
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
  validates :age, presence: true, numericality: { less_than: 121, message: "must be less than 120" }



  def admin?
    role.role_name == Role::ROLES[:admin]
  end

  def doctor?
    role.role_name == Role::ROLES[:doctor]
  end

  def patient?
    role.role_name == Role::ROLES[:patient]
  end

end
