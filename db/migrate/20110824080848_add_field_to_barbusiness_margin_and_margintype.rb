class AddFieldToBarbusinessMarginAndMargintype < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :margin ,:integer
    add_column :bar_bussinesses, :margin_type, :string
  end

  def self.down
    remove_column :bar_bussinesses, :margin
    remove_column :bar_bussinesses, :margin_type
  end
end
