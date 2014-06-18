# encoding: utf-8
class Book < ActiveRecord::Base
	
	validates :isbn, presence: true
	validates :title, presence: true
	validates :tags, presence: true
	validates :author, presence: true
	validates :price, presence: true
	validates :currency, presence: true

	validates :currency,
	   inclusion: { in: %w(GBP EUR USD),    message: "%{value} is not a valid value for curency."}

	before_save :normalize_data

	def normalize_data
		self.isbn = self.isbn.upcase.gsub("[\s\W]","")
		self.title = self.title.upcase.gsub("[\s\w]","")
		self.tags = self.tags.upcase.gsub("[\s\w]","")
		self.author = self.author.upcase.gsub("[\s\w]","")
		self.currency = self.currency.upcase.gsub("[\s\w]","")
	end
end