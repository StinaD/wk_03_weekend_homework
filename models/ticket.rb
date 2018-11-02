require_relative('../db/sql_runner.rb')

class Ticket

  attr_reader :customer_id
  attr_accessor :film_id

  def initialize( options )
    @id = options["id"].to_i if options["id"]
    @customer_id = options["customer_id"]
    @film_id = options["film_id"]
  end


# class functions -----------
  def self.all
    sql = "SELECT * FROM tickets"
    all_tickets = SqlRunner.run(sql)
    return all_tickets.map { |ticket| Ticket.new(ticket) }
  end

  def self.delete_all
    sql = "DELETE from tickets"
    SqlRunner.run(sql)
  end


# instance functions -------
  def save_ticket
    sql = "INSERT into tickets ( customer_id, film_id ) VALUES ( $1, $2 ) RETURNING id;"
    values = [ @customer_id, @film_id ]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def find
    sql = "SELECT * FROM tickets WHERE id = $1;"
    values = [@id]
    result = SqlRunner.run(sql, values)
    tickets_hash = result.first
    return Ticket.new(tickets_hash)
  end

  def update
    sql = "UPDATE tickets SET ( customer_id, film_id ) = ( $1, $2 ) WHERE id = $3;"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end
