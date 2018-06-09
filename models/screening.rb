require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :screening_time, :film_id

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @screening_time = options['time']
    @film_id = options['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
    (
      screening_time,
      film_id
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@screening_time, @film_id]
    screenings = SqlRunner.run( sql, values ).first
    @id = screenings['id'].to_i
  end


  def update
    sql = "UPDATE screenings SET screening_time = $1 WHERE id = $2"
    values = [@screening_time, @id]
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


  def self.map_items(screening_data)
    return screening_data.map {|screening| Screening.new(screening)}
  end

end
