class AddFieldInBarBussinessPersistenceToken < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :persistence_token, :string
  end

  def self.down
    remove_column :bar_bussinesses, :persistence_token
  end
end
