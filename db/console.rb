require_relative('../models/customer')
require_relative('../models/film')
require_relative('../models/ticket')
require_relative('../models/screening')

require( 'pry-byebug' )

Customer.delete_all()
Film.delete_all()
Screening.delete_all()
Ticket.delete_all()

customer1 = Customer.new({ 'name' => 'Shaun', 'funds' => 10 })
customer2 = Customer.new({ 'name' => 'Rachel', 'funds' => 12 })

customer1.save()
customer2.save()

film1 = Film.new({ 'title' => 'Deadpool', 'price' => 10 })
film2 = Film.new({ 'title' => 'Grease', 'price' => 12 })

film1.save()
film2.save()

screening1 = Screening.new({ 'time' => '23:00', 'film_id' => film1.id })
screening1.save()

ticket1 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer1.id })
ticket2 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer1.id })
ticket3 = Ticket.new({ 'film_id' => film1.id, 'customer_id' => customer2.id })

ticket1.save()
ticket2.save()
ticket3.save()

binding.pry
nil
