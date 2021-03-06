require_relative('../db/sql_runner.rb')
require_relative('film.rb')
require_relative('ticket.rb')
require_relative('screening.rb')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options["id"].to_i if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_i
  end

  # class functions -----------
  def self.all
    sql = "SELECT * FROM customers"
    all_customers = SqlRunner.run(sql)
    return all_customers.map { |customer| Customer.new(customer)  }
  end

  def self.delete_all
    sql = "DELETE from customers"
    SqlRunner.run(sql)
  end


  # instance functions --------
  def save_customer
    sql = "INSERT into customers ( name, funds)
    VALUES ( $1, $2 )
    RETURNING id;"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def find
    sql = "SELECT * FROM customers WHERE id = $1;"
    values = [@id]
    result = SqlRunner.run(sql, values)
    customers_hash = result.first
    return Customer.new(customers_hash)
  end

  def update
    sql = "UPDATE customers SET ( name, funds ) = ( $1, $2 ) WHERE id = $3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def find_film
    sql = "SELECT films.title
    FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    INNER JOIN customers
    ON tickets.customer_id = customers.id
    WHERE customers.id = $1;"
    values = [@id]
    result = SqlRunner.run(sql, values)
    film_hash = result.first
    return Film.new(film_hash).title
  end

  def sufficient_funds?(film)
    @funds >= film.price
  end

  def buy_ticket(film, screening)
    if (screening.max_capacity > screening.number_of_tickets_sold) &&     sufficient_funds?(film)
      @funds -= film.price
      ticket = Ticket.new({"customer_id" => @id, "screening_id" => screening.id})
      ticket.save_ticket
    else
      p "Screening is fully booked"
    end
  end

  def films
    sql = "SELECT tickets.*
    FROM tickets
    INNER JOIN customers
    ON customers.id = tickets.customer_id
    WHERE customers.id = $1;"
    values = [@id]
    result = SqlRunner.run(sql, values)
    tickets = result.map { |ticket| Ticket.new(ticket) }
    tickets.count
  end


end
