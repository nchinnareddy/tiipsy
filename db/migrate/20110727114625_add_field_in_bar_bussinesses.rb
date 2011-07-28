class AddFieldInBarBussinesses < ActiveRecord::Migration
  def self.up
    change_table(:bar_bussinesses) do |t|
      t.change :description, :text
      t.change :start_date, :string
      t.change :end_date, :string
    end
  end

  def self.down
  end
end
