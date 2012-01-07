class GuestList < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :email, :scope => [:user_id, :product]
end
