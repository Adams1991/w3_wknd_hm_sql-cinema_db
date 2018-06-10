require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :screening_time, :film_id, :available_tickets

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @screening_time = options['screening_time']
    @film_id = options['film_id'].to_i
    @available_tickets = options['available_tickets'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
    (
      screening_time,
      film_id,
      available_tickets
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@screening_time, @film_id, @available_tickets]
    screenings = SqlRunner.run( sql, values ).first
    @id = screenings['id'].to_i
  end


  def update
    sql = "UPDATE screenings SET screening_time = $1 WHERE id = $2"
    values = [@screening_time,@available_tickets, @id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    values = []
    screenings = SqlRunner.run(sql, values)
    result = Screening.map_items(screenings)
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    values = []
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def tickets_sold_for_screening()
    sql = "SELECT tickets.*
    FROM tickets
    WHERE screening_id = $1"
    values = [@id]
    ticket_count = SqlRunner.run(sql, values).count()
    return ticket_count
  end

  def self.find_screening_id(film_id)
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [film_id]
    screenings = SqlRunner.run(sql, values)
    result = Screening.map_items(screenings)
    id_array = result.map{ |screening| screening.id()}
    return id_array[0]
  end

  

  def self.map_items(screening_data)
    return screening_data.map {|screening| Screening.new(screening)}
  end

end
