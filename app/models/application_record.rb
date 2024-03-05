class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # ROLES = {
  #   admin: 'admin',
  #   doctor: 'doctor',
  #   patient: 'patient'
  # }.freeze
end
