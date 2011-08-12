class Addfieldtoservicelistings < ActiveRecord::Migration
  def self.up
    change_column :servicelistings, :phone, :string
  end

  def self.down
    change_column :servicelistings, :phone, :integer
  end
end
