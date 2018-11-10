class CreateMissingdetails < ActiveRecord::Migration[5.2]
  def change
    create_table :missingdetails do |t|
      t.integer :count , null: false, default: 0
      t.string :name , null: false 
      t.string :area , null: false
      t.text :address , null: false
      t.integer :elevel , default: 0
      t.string :glocation , null: false
      t.string :u_id , null: false
      t.string :r_id , default: 0
      t.string :status
      t.timestamps
    end
  end
end
