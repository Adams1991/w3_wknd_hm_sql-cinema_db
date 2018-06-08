require_relative('../models/customer')
require_relative('../models/film')

require( 'pry-byebug' )

Customer.delete_all()

customer1 = Customer.new({ 'name' => 'Shaun', 'funds' => 10 })
customer1.save()


film1 = Film.new({ 'title' => 'Deadpool', 'price' => 10 })
film1.save()

binding.pry
nil
