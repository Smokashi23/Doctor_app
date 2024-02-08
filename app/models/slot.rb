class Slot < ApplicationRecord
  belongs_to :user
  has_one :appt
end
