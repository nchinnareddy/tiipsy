class AddFieldToNewBarBussinessRegistration < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :website, :string
  end

  def self.down
    remove_column :bar_bussinesses, :website
  end
end
