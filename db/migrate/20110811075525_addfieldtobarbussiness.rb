class Addfieldtobarbussiness < ActiveRecord::Migration
  def self.up
    change_column :bar_bussinesses, :phone, :string
  end

  def self.down
    change_column :bar_bussinesses, :phone, :integer
  end
end
