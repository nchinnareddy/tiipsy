class AddDefaultCardToCreditCards < ActiveRecord::Migration
  def self.up
    add_column :credit_cards, :default_card, :boolean
  end

  def self.down
    remove_column :credit_cards, :default_card
  end
end
