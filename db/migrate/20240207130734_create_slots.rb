class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.references :user, foreign_key: true
      t.date :available_days
      t.time :available_time

      t.timestamps
    end
  end
end
