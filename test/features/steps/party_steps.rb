Given(/^A user requests a json request for get \/books\/json$/) do
  
  # Simple command line approach	
  #@response = HTTParty.get("http://localhost:4567/books/json")

  # Modular approach approach
  #bookService = BookService.new
  @response = @bookService.get_books
end

Then(/^The user should receive a valid json response$/) do
	@json_response = []
    expect {@json_response = JSON.parse(@response.body)}.not_to raise_error
end

Then(/^There should be some book data returned in json format$/) do
  @json_response.first.should be_a_kind_of Hash
end

Given(/^A user requests a json request for get \/books\/xml$/) do
  #bookService = BookService.new
  @response = @bookService.get_books(format = :xml)
end

Then(/^The user should receive a valid xml response$/) do
	
	expect {
		@xml_response = Nokogiri::XML(@response.body) { |config| config.strict }
		}.not_to raise_error 
end

Then(/^There should be some book data returned in xml format$/) do
	@xml_response.css("book").first.should be_a_kind_of Nokogiri::XML::Element
end

#
# service content check
#

Given(/^A user requests info for a book (#{ISBN}) in (xml|json) format$/) do |isbn_10,format|

  #bookService = BookService.new
  @format = format
  case format
  when "xml"
  	@response = @bookService.get_book_by_isbn(format=:xml,isbn=isbn_10)
  when "json"
  	@response = @bookService.get_book_by_isbn(format=:json,isbn=isbn_10)
  end
  #debugger
  #p "Done"
end

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

Then(/^The author should be (.+)$/) do |author|
  	@bookService.get_info_from_response(response=@response,data="author").should eq(author)
end

Then(/^Book should be priced at (#{PRICE}) (.+)$/) do |price,currency|
	case @format
	when "xml"
  		Nokogiri.XML(@response.body).css("price").text.should eq(price)
  	when "json"
  		JSON.parse(@response.body)["price"].should eq(price)
  	end
end
