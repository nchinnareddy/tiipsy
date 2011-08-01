class BarBussiness < ActiveRecord::Base
  validates_presence_of :name, :message => "Please enter bar Name"
  validates_presence_of :person_of_contact, :message => "Please enter Person of Contact"
  validates_presence_of :email, :message => "Email is mandatory field, it can't be blanck"
  validates_presence_of :address, :message => "Please enter address of Bar"  
end
