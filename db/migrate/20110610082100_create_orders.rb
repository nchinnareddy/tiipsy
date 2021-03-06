class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :user
      t.references :servicelisting
      t.string  :description
      t.string  :ip_address
      t.integer :amount
      t.string  :state
      t.string  :express_token
      t.string  :express_payer_id
      t.string  :first_name
      t.string  :last_name
      t.string  :card_type
      t.string  :card_number
      t.string  :card_verification
      t.date    :card_expires_on
      t.string  :address
      t.string  :city
      t.string  :state_name
      t.string  :country
      t.string  :zip
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
