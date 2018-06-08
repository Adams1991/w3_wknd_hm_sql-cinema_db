require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :time, :film_id

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


end
