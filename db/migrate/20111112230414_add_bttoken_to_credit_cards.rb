class AddBttokenToCreditCards < ActiveRecord::Migration
  def self.up
    add_column :credit_cards, :bttoken, :string
  end

  def self.down
    remove_column :credit_cards, :bttoken
  end
end
