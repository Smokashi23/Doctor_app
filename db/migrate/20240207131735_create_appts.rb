class CreateAppts < ActiveRecord::Migration[7.1]
  def change
    create_table :appts do |t|
      t.references :user, foreign_key: true, null:false
      t.references :slot, foreign_key: true, null:false

    

      t.timestamps
    end
  end
end
