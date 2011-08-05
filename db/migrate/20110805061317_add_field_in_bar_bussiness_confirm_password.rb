class AddFieldInBarBussinessConfirmPassword < ActiveRecord::Migration
  def self.up
    add_column :bar_bussinesses, :password_confirmation, :string
  end

  def self.down
    remove_column :bar_bussinesses, :password_confirmation
  end
end
