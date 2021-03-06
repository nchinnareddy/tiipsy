class CreateServicelistings < ActiveRecord::Migration
  def self.up
    create_table :servicelistings do |t|
  t.string    :title
  t.text      :description
  t.string    :location
  t.datetime  :availability
  t.float     :price
  t.float     :buynow_price, :default => 0.0
  t.integer   :no_of_guests
  t.float     :highestbid, :default => 0.0
  t.string    :status, :default => "inactive"
  t.integer   :winner_id, :default => false

  t.timestamps
    end
  end

  def self.down
    drop_table :servicelistings
  end
end
