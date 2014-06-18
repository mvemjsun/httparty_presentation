require 'active_record'
require 'yaml'
require 'logger'
require 'faker'
require 'cucumber/rake/task'
require_relative 'models/book'
require_relative 'models/seed/helper'
require_relative 'models/seed/book_seed'

namespace :db do

	def create_my_database
		p "Create DB"
	end

	task :configure do
		p "Task Reading configuration ..."
		@config = YAML.load_file('config.database')['development']
	end

	task :connect_to_db do
		p "Task Establishing connection ..."
		ActiveRecord::Base.establish_connection @config
		ActiveRecord::Base.logger = Logger.new(File.open('logs/migrations.log', 'a'))
	end

	task :migrate => [:configure, :connect_to_db] do
		p "Task Migrate ..."
		ActiveRecord::Migration.verbose = true	
		x=ENV['VERSION'] || '1';
		p "Migration version #{x}"
		ActiveRecord::Migrator.migrate './models/migrations', ENV['VERSION'] ? ENV['VERSION'].to_i : nil
	end

	task :rollback => [:configure, :connect_to_db] do
		# Default rollback to 1 step if STEP not specified in rake command
		rollback_steps = ENV['STEPS'] ? ENV['STEPS'].to_i : 1
		p "Rollback by #{rollback_step} step(s)"
		ActiveRecord::Migrator.rollback './models/migrations', rollback_steps
	end

	task :drop_database do
		p "Dropping database ..."
	end	

	task :prepare => [:configure, :connect_to_db] do
		p 'Populating initial data.'
		create_seed_data
	end

end

namespace :test do
	Dir.chdir("./test")
	Cucumber::Rake::Task.new(:normal) do |task|  
		profile = ENV['PROFILE'] || 'default'
		task.cucumber_opts = "--format html -o party_test_report.html"
	end
end