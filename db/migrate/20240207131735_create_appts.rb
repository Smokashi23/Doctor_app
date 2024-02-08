class CreateAppts < ActiveRecord::Migration[7.1]
  def change
    create_table :appts do |t|
      t.references :user, foreign_key: true
      t.references :slot, foreign_key: true

    

      t.timestamps
    end
  end
end
