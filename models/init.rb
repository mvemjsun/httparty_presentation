# encoding: utf-8
require 'mysql2'
require 'active_record'

@db
log = File.new("logs/sinatra.log", "a")
#$stdout.reopen(log)
$stderr.reopen(log)
$stderr.sync = true
#$stdout.sync = true

connect_to_db = lambda do 
	if ENV['RUBY_ENV'] == 'PRODUCTION'
		app_env = 'production'
	else
		app_env = 'development'
	end

	@db=ActiveRecord::Base.establish_connection YAML.load_file('config.database')[app_env]
  	ActiveRecord::Base.logger = Logger.new(File.open('logs/db.log', 'a')) if app_env == 'development'
end
connect_to_db.call

require_relative 'book'