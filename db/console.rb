require_relative('../models/customer')

require( 'pry-byebug' )

Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Shaun', 'funds' => 10 })
customer1.save()

binding.pry
nil
