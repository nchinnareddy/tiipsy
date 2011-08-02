class AddFieldStatusInNewBarBussinesses < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :status, :integer , :default => 0
  end

  def self.down
    remove_column :bar_bussinesses, :status
  end
end
