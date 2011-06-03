class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.float :bidprice
      t.references :user
      t.references :servicelisting

      t.timestamps
    end
  end

  def self.down
    drop_table :bids
  end
end
