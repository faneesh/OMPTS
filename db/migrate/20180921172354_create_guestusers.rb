class CreateGuestusers < ActiveRecord::Migration[5.2]
  def change
    create_table "guestusers" do |t|
    t.string :email , null: false
    t.string :name, null: false
    t.text :contactno, null: false
    
  end
    
    
  end
end
