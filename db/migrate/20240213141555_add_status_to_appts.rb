class AddStatusToAppts < ActiveRecord::Migration[7.1]
  def change
    add_column :appts, :status, :string, default: "confirmed"
  end
end
