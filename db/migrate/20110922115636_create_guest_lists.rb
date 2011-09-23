class CreateGuestLists < ActiveRecord::Migration
  def self.up
    create_table :guest_lists do |t|
      t.string :name
      t.string :email
      t.string :provider
      t.timestamps
    end
  end

  def self.down
    drop_table :guest_lists
  end
end
