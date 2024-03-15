class Slot < ApplicationRecord
  belongs_to :user
  has_one :appointment
  
  validates :available_time, uniqueness: { scope: [:available_days, :user_id], message: "has already been taken by this user" }
  validate :available_days_greater_than_or_equal_to_current_date

  private
  def available_days_greater_than_or_equal_to_current_date
    if available_days.present? && available_days < Date.today
      errors.add(:available_days, "must be greater than or equal to the current date")
    end
  end
end


