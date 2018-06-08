require_relative('../models/customer')

require( 'pry-byebug' )

customer1 = Customer.new({ 'name' => 'Shaun', 'funds' => 10 })
customer1.save()

binding.pry
nil
