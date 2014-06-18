# encoding: utf-8

class BookApp < Sinatra::Application
	
	#
	# GET a list of all the books in the requested format
	# /books/:format
	#
	# @param [:format] format of send data, either json or xml
	#
	# @example Get a list of all books in json format
	#     /books/json
	#
	# @example Get a list of all books in xml format
	#     /books/xml
	#
	get "/books/:format" do
		f = params[:format]
		books = Book.all
		case f
		when 'json'
			content_type :json
			books.to_json
		when 'xml'
			content_type :xml
			books.to_xml
		end
	end

	#
	# GET a book info in the requested format
	#
	# /book/isbn/:isbn/:format
	# @param [:isbn] isbn number of the book
	# @param [:format] format of the data
	#
	# @example Get book info json format searching using isbn
	#     /book/isbn/1234567890/json
	#
	# @example Get book info xml format searching using isbn
	#     /book/isbn/1234567890/xml
	#

	get "/book/isbn/:isbn/:format" do
		isbn = params[:isbn]
		f = params[:format]
		book = Book.find_by_isbn(isbn)

		case f 
		when 'json'
			content_type :json
			if book
				book.to_json
			else
				{"status_message" => "Book not found"}.to_json
			end
		when 'xml'
			content_type "text/xml"
			if book
				book.to_xml 
			else
				"<?xml version=\"1.0\"?><status_message>Book not found</status_message>" unless book
			end
		end

	end
end