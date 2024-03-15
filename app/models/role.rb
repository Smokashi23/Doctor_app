class Role < ApplicationRecord
  has_many :users
  validates :name, presence: true
  ROLES = {
  admin: 'admin',
  doctor: 'doctor',
  patient: 'patient'
}.freeze
end



