class CreateOrderTransactions < ActiveRecord::Migration
  def self.up
    create_table :order_transactions do |t|
      t.integer :amount
      t.boolean :success
      t.string :reference
      t.string :message
      t.string :action
      t.text :params
      t.boolean :test
      t.references :order

      t.timestamps
    end
  end

  def self.down
    drop_table :order_transactions
  end
end
