class User < ApplicationRecord
  belongs_to :role
  has_many :appointments, dependent: :destroy
  has_many :slots, dependent: :destroy
  validates :email, presence: true, uniqueness: { message: I18n.t('user.already_exists') }, format: { with: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]+\z/i, message: I18n.t('user.regrex_invalid')}
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
  validates :age, presence: true, numericality: { less_than: 121, message: "must be less than 120" }

  def admin?
    role.name == Role::ROLES[:admin]
  end

  def doctor?
    role.name == Role::ROLES[:doctor]
  end

  def patient?
    role.name == Role::ROLES[:patient]
  end

end
