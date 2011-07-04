class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :description
      t.integer :amount
      t.string :state
      t.string :express_token
      t.string :express_payer_id
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.string :card_number
      t.string :card_verification
      t.date   :card_expires_on
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
