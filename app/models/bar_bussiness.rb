class BarBussiness < ActiveRecord::Base
  
  acts_as_gmappable
      def gmaps4rails_address
          address
      end
       def gmaps4rails_infowindow
         "<h4>#{name}</h4>" << "<h4>#{address}</h4>"
       end

  has_attached_file :photo 
  #validates_attachment_size :photo, :less_than => 2.megabytes , :message => "must be less than 2 megabytes"
  
  validates_presence_of :name, :message => "Please enter bar Name"
  validates_presence_of :person_of_contact, :message => "Please enter Person of Contact"
  validates_numericality_of :phone , :message => "Phone should be number"
  #validates_inclusion_of :website, :in => %w(http://), :message => "extension http:// is not included in the list"
  validates_presence_of :email, :message => "Email is mandatory field, it can't be blanck"
  validates_presence_of :address, :message => "Please enter address of Bar" 
  validates_uniqueness_of :name , :message => "This bar name is already registerd"
  validates_uniqueness_of :address , :message => "This address is already registerd"
  validates_uniqueness_of :email
  validates :email, :email_format => true
  
 # def new_random_password
  #  self.password= Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--")[0,6]
  #  return password
    #self.password_confirmation = self.password  #not part of code
 #end
   
end
