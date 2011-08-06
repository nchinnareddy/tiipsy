class AddFieldInUserBarowner < ActiveRecord::Migration
  def self.up
    add_column :users, :barowner, :boolean, :default => false
  end

  def self.down
    remove_column :users, :barowner
  end
end
