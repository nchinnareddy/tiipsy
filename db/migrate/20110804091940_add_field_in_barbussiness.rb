class AddFieldInBarbussiness < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :password, :string
  end

  def self.down
    remove_column :bar_bussinesses, :password
  end
end
