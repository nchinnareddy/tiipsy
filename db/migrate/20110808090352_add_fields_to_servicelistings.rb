class AddFieldsToServicelistings < ActiveRecord::Migration
  def self.up
    add_column :servicelistings , :bar_name , :string
    add_column :servicelistings , :person_of_contact , :string
    add_column :servicelistings , :phone , :integer
    add_column :servicelistings , :email , :string
    add_column :servicelistings , :website , :string
    change_column :servicelistings, :availability, :datetime
  end

  def self.down
    remove_column :servicelistings , :bar_name
    remove_column :servicelistings , :person_of_contacts
    remove_column :servicelistings , :phone
    remove_column :servicelistings , :email 
    remove_column :servicelistings , :website 
    change_column :servicelistings, :availability, :string
  end
end
