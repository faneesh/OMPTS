class CreateRescueteams < ActiveRecord::Migration[5.2]
  def change
    create_table :rescueteams do |t|
      t.string :name 
      t.string :email , uniqueness: true
      t.string :password_digest
      t.string :area
      t.string :teamsize
      t.string :contactno
      t.timestamps
      
    end
    
   end
end
