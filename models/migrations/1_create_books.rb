class CreateBooks < ActiveRecord::Migration

	def self.up
		create_table :books do |t|
			t.string :isbn, null: false
			t.string :title, null: false
			t.string :tags, null: false
			t.string :author, null: false
			t.decimal :price, null: false, precision: 4, scale: 2
			t.string :currency, null: false
			t.timestamps
		end

		add_index :books, :isbn, unique: true
		add_index :books , :author
		add_index :books , :title
	end

end