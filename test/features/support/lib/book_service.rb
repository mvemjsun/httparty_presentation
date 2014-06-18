require 'httparty'

class BookService
	include HTTParty
	base_uri "http://localhost:4567"

	def initialize()

	end

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