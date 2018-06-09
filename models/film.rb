require_relative("../db/sql_runner")
require_relative('./ticket')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films
    (
      title,
      price
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@title, @price]
    films = SqlRunner.run( sql, values ).first
    @id = films['id'].to_i
  end

  def update
    sql = "UPDATE films SET title = $1, price = $2 WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films"
    values = []
    films = SqlRunner.run(sql, values)
    result = Film.map_items(films)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE film_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return Customer.map_items(customer_data)
  end

  def customer_attendance()
    sql = "SELECT tickets.*
    FROM tickets
    WHERE film_id = $1"
    values = [@id]
    customer_attendance = SqlRunner.run(sql, values).count()
    return customer_attendance
  end

  def all_tickets_sold_for_film()
    sql = "SELECT tickets.*
    FROM tickets
    LEFT JOIN screenings
    ON screenings.id = tickets.screening_id
    WHERE screenings.film_id = $1"
    values = [@id]
    ticket_data = SqlRunner.run(sql, values)
    return Ticket.map_items(ticket_data)
  end

  def most_popular_screening_id
    ticket_array = all_tickets_sold_for_film
    id_array = ticket_array.map{ |ticket| ticket.screening_id()}
    
  end

  def self.map_items(film_data)
    return film_data.map {|film| Film.new(film)}
  end

end
