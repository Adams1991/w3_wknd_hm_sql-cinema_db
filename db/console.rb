require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')

require( 'pry-byebug' )

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new({ 'name' => 'Shaun', 'funds' => 10 })

customer1.save()

film1 = Film.new({ 'title' => 'Deadpool', 'price' => 10 })

film1.save()

ticket1 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer1.id })

ticket1.save()

binding.pry
nil
