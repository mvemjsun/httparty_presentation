# encoding: utf-8
require 'sinatra'

#require_relative 'minify_resources'
class BookApp < Sinatra::Application
	#enable :sessions
	use Rack::Session::Pool

	configure :production do

	end

	configure :development do

	end

	helpers do

	end
end

require_relative 'helpers/init'
require_relative 'models/init'
require_relative 'routes/init'