require_relative('../db/sql_runner.rb')


class Screening

  attr_reader :id
  attr_accessor :film_id, :time, :max_capacity

  def initialize ( options )
    @id = options["id"].to_i if options["id"]
    @film_id = options["film_id"]
    @time = options["time"].to_i
    @max_capacity = options["max_capacity"].to_i
    # question - whats the syntax for an array variable? Do you set up an empty array here or in the console?
  end


# class functions -----------

  def self.delete_all
    sql = "DELETE from screenings"
    SqlRunner.run(sql)
  end

  def self.all
    sql = "SELECT * FROM screenings"
    all_screenings = SqlRunner.run(sql)
    return all_screenings.map { |screening| Screening.new(screening) }
  end

# instance functions -------

  def save_screening
    sql = "INSERT into screenings ( film_id, time ) VALUES ( $1, $2 ) RETURNING id;"
    values = [ @film_id, @time ]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def number_of_tickets_sold
    sql = "SELECT tickets.*
    FROM tickets
    INNER JOIN screenings
    ON tickets.screening_id = screenings.id
    WHERE screenings.id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    tickets = results.map { |ticket| Ticket.new(ticket) }
    p tickets.count
  end


end
