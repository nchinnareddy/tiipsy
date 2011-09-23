class AddToGuestUserServiceAndUser < ActiveRecord::Migration
  def self.up
    add_column :guest_lists ,:user_id, :integer
    add_column :guest_lists ,:product, :string
  end

  def self.down
    remove_column :guest_lists, :user_id
    remove_column :guest_lists, :product
  end
end
