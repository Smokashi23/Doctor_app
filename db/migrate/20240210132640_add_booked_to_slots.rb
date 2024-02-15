class AddbookededToSlots < ActiveRecord::Migration[7.1]
  def change
    add_column :slots, :booked, :boolean, default: false
  end
end
