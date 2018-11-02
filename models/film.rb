require_relative('../db/sql_runner.rb')
require_relative('customer.rb')

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
    sql = "SELECT * FROM films"
    all_films = SqlRunner.run(sql)
    return all_films.map { |film| Film.new(film) }
  end

  def self.delete_all
    sql = "DELETE from films"
    SqlRunner.run(sql)
  end


  # instance functions -------
  def save
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


end
