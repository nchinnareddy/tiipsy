class CreateServicelistings < ActiveRecord::Migration
  def self.up
    create_table :servicelistings do |t|
  t.string  :title
  t.text    :description
  t.string  :location
  t.date    :availability
  t.string  :price
  t.integer :no_of_guests
  t.boolean :status, :default => false

  t.timestamps
    end
  end

  def self.down
    drop_table :servicelistings
  end
end
