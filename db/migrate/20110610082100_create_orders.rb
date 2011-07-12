class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :description
      t.integer :amount
      t.string :state
      t.string :express_token
      t.string :express_payer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
