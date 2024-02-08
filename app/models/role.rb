class Role < ApplicationRecord
  has_many :users
  validates :role, inclusion: { in: %w(doctor patient), message: "should be 'doctor' or 'patient'" 
end
