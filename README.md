## Sinatra HTTParty and more

### Introduction

Exploring HTTParty to test a ReST web service. This repository implements a Sinatra application as a ReST web service that responds to the below GET requests (the actual 10 digit numbers may be different depending on the data in your database).

```
1. /books/json`
2. /books/xml
3. /book/isbn/1234567890/json
4. /book/isbn/1234567890/xml
```
We use HTTParty to test these requests via cucumber features.

### To get Started

* Logon to MySQL and create a database using `create database httparty`
* Run the database migration `rake db:migrate`
* Populate the database with seed data using `rake db:prepare`. Note that this step creates random data in the
  `books` table and you will need to adjust your feature examples to match your data (i.e the `isbn`, `title`, `author` & `currency` columns)
* Check the database to ensure that the `books` table is created with the test data populated.

```
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
| isbn       | varchar(255) | NO   | UNI | NULL    |                |
| title      | varchar(255) | NO   | MUL | NULL    |                |
| tags       | varchar(255) | NO   |     | NULL    |                |
| author     | varchar(255) | NO   | MUL | NULL    |                |
| price      | decimal(4,2) | NO   |     | NULL    |                |
| currency   | varchar(255) | NO   |     | NULL    |                |
| created_at | datetime     | YES  |     | NULL    |                |
| updated_at | datetime     | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
```

* Start the Sinatra webservice on a port of your choice using `rackup -p 4567`.
* To run the tests execute `rake test:normal` which will result in (Please change example data to match your database data)

```
  Scenario: Request a full book list in json format
    Given A user requests a json request for get /books/json
    Then The user should receive a valid json response
    And There should be some book data returned in json format

  Scenario: Request a full book list in xml format
    Given A user requests a json request for get /books/xml
    Then The user should receive a valid xml response
    And There should be some book data returned in xml format

  Scenario Outline: Service request for a specific book by isbn
    Given A user requests info for a book <isbn> in <format> format
    Then The book title should be <title>
    And The author should be <author>
    And Book should be priced at <price> <currency>

    Examples:
      | isbn       | format | title          | author             | price | currency |
      | 4427075523 | xml    | EULAH JOHNS IV | ELVERA QUIGLEY     | 10.99 | USD      |
      | 3459639964 | json   | OWEN BRAKUS    | MRS. FORREST NOLAN | 10.99 | GBP      |

4 scenarios (4 passed)
14 steps (14 passed)
0m0.740s
```

### HTTParty tests

HTTParty is built on top of Net::HTTP ruby HTTP client API.

#### Simple usage

In its simplest form it can be used directly within the code using  
```ruby
@response = HTTParty.get("http://localhost:4567/books/json")
```
The response can be then probed further using the various methods. Some of the useful ones are the
`body`, `code`,`status` & `headers` methods.

A typical usage could be
```ruby
Given(/^A user requests a json request for get \/books\/json$/) do 
  @response = HTTParty.get("http://localhost:4567/books/json")
end
```

#### Modular usage
HTTParty allows for its use as a mixin. I particularly like this approach as any of the ReST service
complexities can be hidden away into the "service class". The way this can be achieved is

```ruby
class BookService
	include HTTParty
	base_uri "http://localhost:4567"
end	
```

With this approach I can now abstract the service interaction as follows

```ruby
class BookService

	include HTTParty
	base_uri "http://localhost:4567"
	
	def get_books(format=:json)
		response = self.class.get("/books/json") if format == :json
		response = self.class.get("/books/xml") if format == :xml
		response
	end

	def get_book_by_isbn(format=:json,isbn=0)
		response = self.class.get("/book/isbn/#{isbn}/json") if format == :json
		response = self.class.get("/book/isbn/#{isbn}/xml") if format == :xml
		response
	end

	#
	# gets a piece of response data from either a json or xml response for a book
	#
	def get_info_from_response(response,data)

		content_type = response.headers["content-type"]

		case content_type
		when "application/json"
			JSON.parse(response.body)[data]
		when "text/xml;charset=utf-8"
			Nokogiri.XML(response.body).css(data).text
		end
	end
end
```

##### Cucumber steps and refactoring

With the above HTTParty service class in place, I can now refactor the cucumber step as shown below

```ruby

...

Then(/^The book title should be (.+)$/) do |title|
	# case @format
	# when "xml"
    # 	Nokogiri.XML(@response.body).css("title").text.should eq(title)
    # when "json"
    # 	JSON.parse(@response.body)["title"].should eq(title)
    # end
    #
    # Code refactored as below by using HTTParty modular approach
    #
 	@bookService.get_info_from_response(response=@response,data="title").should eq(title)
end

...

```

#### Summary

I have just scratched the surface of what HTTParty can do, but hope that you find this starter pack useful to get started.

#### References

1. [HTTParty on Github] (https://github.com/jnunemaker/httparty)
2. [Sinatra] (http://www.sinatrarb.com/)
