class AddFieldUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :zip, :integer
  end

  def self.down
  end
end
