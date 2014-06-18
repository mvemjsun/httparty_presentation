
def create_seed_data
	10.times do 
		book = Book.new
		book.isbn = Faker::Number.number(10)
		book.title = Faker::Name.name.upcase
		book.tags = Helper.randomize_data ['IT', 'SPORTS','FICTION','GEOGRAPHY']
		book.author = Faker::Name.name.upcase
		book.price = Helper.randomize_data [10.99,15.00,10,29]
		book.currency = Helper.randomize_data ['GBP', 'USD','EUR']
		book.save
	end
end