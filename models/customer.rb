require_relative("../db/sql_runner")
require_relative('./ticket')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers
    (
      name,
      funds
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @funds]
    customers = SqlRunner.run( sql, values ).first
    @id = customers['id'].to_i
  end

  def update
    sql = "UPDATE customers SET name = $1, funds = $2 WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    customers = SqlRunner.run(sql, values)
    result = Customer.map_items(customers)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.*
    FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return Film.map_items(film_data)
  end

  def tickets_bought()
    sql = "SELECT tickets.*
    FROM tickets
    WHERE customer_id = $1"
    values = [@id]
    ticket_count = SqlRunner.run(sql, values).count()
    return ticket_count
  end

  def buy_ticket(film_name)
    sql = "SELECT * FROM films WHERE title = $1"
    values = [film_name]
    film = SqlRunner.run(sql, values)
    film_hash = film[0]
    @funds -= film_hash['price'].to_i
    update()
    ticket = Ticket.new({ 'film_id' => film_hash['id'].to_i, 'customer_id' => @id })
    ticket.save()
    return ticket
  end

  def self.find(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    customer_hash = result[0]
    customer = Customer.new(customer_hash)
    return customer
  end

  def self.map_items(customer_data)
    return customer_data.map {|customer| Customer.new(customer)}
  end

end
