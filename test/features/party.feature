Feature: Book info ReST service
	
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
	| isbn        | format     | title               | author            | price | currency |
	| 4427075523  | xml        | EULAH JOHNS IV      | ELVERA QUIGLEY    | 10.99 | USD      |
	| 3459639964  | json       | OWEN BRAKUS         | MRS. FORREST NOLAN| 10.99 | GBP      |