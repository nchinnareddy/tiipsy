class AddFieldsInServicelisting < ActiveRecord::Migration
  def self.up
    add_column :servicelistings, :city, :string
  end

  def self.down
    remove_column :servicelistings, :city
  end
end
