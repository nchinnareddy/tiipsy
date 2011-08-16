class BarBussiness < ActiveRecord::Base
  

  has_attached_file :photo
  
  validates_presence_of :name, :message => "Please enter bar Name"
  validates_presence_of :person_of_contact, :message => "Please enter Person of Contact"
  
  validates_presence_of :email, :message => "Email is mandatory field, it can't be blanck"
  validates_presence_of :address, :message => "Please enter address of Bar" 
  
  validates_uniqueness_of :name , :message => "This bar name is already registerd"
  validates_uniqueness_of :email
  
  validates :email, :email_format => true
  
  def new_random_password
    self.password= Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--")[0,6]
    return password
    #self.password_confirmation = self.password
  end
  
  
   
end
