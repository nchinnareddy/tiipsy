class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.float :amount
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
