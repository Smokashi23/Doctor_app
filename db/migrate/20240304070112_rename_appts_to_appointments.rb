class RenameApptsToAppointments < ActiveRecord::Migration[7.1]
  def change
    rename_table :appts, :appointments
  end
end
