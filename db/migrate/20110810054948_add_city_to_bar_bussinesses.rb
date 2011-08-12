class AddCityToBarBussinesses < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :city, :string
  end

  def self.down
    remove_column :bar_bussinesses, :city
  end
end
