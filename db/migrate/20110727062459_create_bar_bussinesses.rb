class CreateBarBussinesses < ActiveRecord::Migration
  def self.up
    create_table :bar_bussinesses do |t|
      t.string :name
      t.integer :person_of_contact
      t.string :email
      t.integer :phone
      t.text :address
      t.datetime :start_date
      t.datetime :end_date
      t.integer :no_of_tabel
      t.integer :price
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :bar_bussinesses
  end
end
