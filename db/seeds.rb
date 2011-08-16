# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
users = [{:login => 'admin', :email => 'nchinnareddy@gmail.com', :admin => 'true', :password => 'admin123', :password_confirmation => 'admin123'}]
users.each do |user|  
  User.create(user)  
end

owners = [ { :name =>'admin', :person_of_contact => 'admin', :address => "Austin", :email => 'nchinnareddy@gmail.com' }]

owners.each do |owner|  
  BarBussiness.create(owner)
end

puts "Admin created"

#roles = [ { :name => 'Super Admin', :identifier => 'superadmin' },
#    { :name => 'Administrative', :identifier => 'admin' },
#    { :name => 'Printing', :identifier => 'print' },
#   ]
#  roles.each do |role|
#    Role.create( role )
#  end
#  puts "Roles created"