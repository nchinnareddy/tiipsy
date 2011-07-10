class CreateCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.string :card_number
      t.string :card_verification
      t.date   :card_expires_on
      t.string :address
      t.string :city
      t.string :state_name
      t.string :country
      t.string :zip
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
