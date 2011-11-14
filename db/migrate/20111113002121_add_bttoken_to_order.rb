class AddBttokenToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :bttoken, :string
  end

  def self.down
    remove_column :orders, :bttoken
  end
end
