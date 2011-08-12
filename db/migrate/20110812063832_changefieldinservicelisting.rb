class Changefieldinservicelisting < ActiveRecord::Migration
  def self.up
    change_column :servicelistings, :status, :string, :default => "active" 
  end

  def self.down
    change_column :servicelistings, :status, :string, :default => "inactive"
  end
end
