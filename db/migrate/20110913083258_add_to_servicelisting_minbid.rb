class AddToServicelistingMinbid < ActiveRecord::Migration
  def self.up
    add_column :servicelistings, :min_bid, :string
  end

  def self.down
    remove_column :servicelistings, :min_bid
  end
end
