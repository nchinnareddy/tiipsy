class Addfieldtobarbussinesses < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :latitude, :float 
    add_column :bar_bussinesses, :longitude, :float 
    add_column :bar_bussinesses, :gmaps, :boolean
  end

  def self.down
    remove_column :bar_bussinesses, :latitude, :float 
    remove_column :bar_bussinesses, :longitude, :float 
    remove_column :bar_bussinesses, :gmaps, :boolean 
  end
end
