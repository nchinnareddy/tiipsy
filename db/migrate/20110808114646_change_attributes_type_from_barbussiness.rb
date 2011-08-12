class ChangeAttributesTypeFromBarbussiness < ActiveRecord::Migration
  def self.up
    change_column :bar_bussinesses, :person_of_contact, :string
  end

  def self.down
    change_column :bar_bussinesses, :person_of_contact, :integer
  end
end
