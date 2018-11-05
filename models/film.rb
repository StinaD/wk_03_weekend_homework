require_relative('../db/sql_runner.rb')
require_relative('customer.rb')
require_relative('screening.rb')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize( options )
    @id = options["id"].to_i if options["id"]
    @title = options["title"]
    @price = options["price"].to_i
  end


# class functions -----------
  def self.all
    sql = "SELECT * FROM films ORDER BY title"
    all_films = SqlRunner.run(sql)
    return all_films.map { |film| Film.new(film) }
  end

  def self.delete_all
    sql = "DELETE from films"
    SqlRunner.run(sql)
  end


  # instance functions -------
  def save_film
    sql = "INSERT into films ( title, price ) VALUES ( $1, $2 ) RETURNING id;"
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def find
    sql = "SELECT * FROM films WHERE id = $1;"
    values = [@id]
    result = SqlRunner.run(sql, values)
    films_hash = result.first
    return Film.new(films_hash)
  end

  def update
    sql = "UPDATE films SET ( title, price ) = ( $1, $2 ) WHERE id = $3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1;"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def find_customers
    sql = "SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    INNER JOIN films
    ON tickets.film_id = films.id
    WHERE films.id = $1;"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map { | customer |
      Customer.new(customer)}
  end

# Basic extension
  def tickets
    sql = "SELECT tickets.*
    FROM tickets
    INNER JOIN films
    ON tickets.film_id = films.id
    WHERE films.id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    tickets = results.map { |ticket| Ticket.new(ticket) }
    return tickets.count
  end

# Advanced extension

  def film_times
    sql = "SELECT screenings.*
    FROM screenings
    INNER JOIN films
    ON films.id = screenings.film_id
    WHERE films.id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    screenings = results.map { | screening | Screening.new(screening).time }
  end

  def most_popular_screening
    sql = "SELECT screenings.*
    FROM screenings
    INNER JOIN films
    ON films.id = screenings.film_id
    WHERE films.id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    screenings = results.map { |screening| Screening.new(screening) }

    screenings_tickets = screenings.map { |screening| {screening.time => screening.number_of_tickets_sold} }

    screenings_tickets.max_by { | key, value| p value }
  end



end
