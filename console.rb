require('pry')
require_relative('models/customer.rb')
require_relative('models/film.rb')
require_relative('models/ticket.rb')

Customer.delete_all
Film.delete_all
Ticket.delete_all

customer1 = Customer.new( {"name" => "Bobby", "funds" => 40} )
customer1.save_customer
customer2 = Customer.new( {"name" => "Jeff", "funds" => 50} )
customer2.save_customer
customer3 = Customer.new( {"name" => "Nick", "funds" => 45} )
customer3.save_customer
customer4 = Customer.new( {"name" => "Derek", "funds" => 50} )
customer4.save_customer

# customer1.name = "Johnny"
# customer1.update

film1 = Film.new( {"title" => "Top Gun", "price" => "4"} )
film1.save_film
film2 = Film.new( {"title" => "Superman", "price" => "5"} )
film2.save_film
film3 = Film.new( {"title" => "Aladdin", "price" => "6"} )
film3.save_film

# film1.title = "Housesitter"
# film1.update

ticket1 = Ticket.new( {"customer_id" => customer1.id, "film_id" => film1.id} )
ticket1.save_ticket
ticket2 = Ticket.new( {"customer_id" => customer2.id, "film_id" => film1.id} )
ticket2.save_ticket
ticket3 = Ticket.new( {"customer_id" => customer3.id, "film_id" => film1.id} )
ticket3.save_ticket
ticket4 = Ticket.new( {"customer_id" => customer4.id, "film_id" => film2.id} )
ticket4.save_ticket
ticket5 = Ticket.new( {"customer_id" => customer4.id, "film_id" => film1.id} )
ticket5.save_ticket

# ticket1.film_id = film3.id
# ticket1.update


binding.pry
nil
