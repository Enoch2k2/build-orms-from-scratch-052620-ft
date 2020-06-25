require 'pry'
require 'sqlite3'

require_relative './intro_to_orms_052620/pet'
 
DB = {:conn => SQLite3::Database.new("db/pet_shop.db")}

DB[:conn].execute("DROP TABLE IF EXISTS pets;")

DB[:conn].execute(
  <<-SQL
    CREATE TABLE pets (
      id INTEGER PRIMARY KEY,
      name TEXT,
      species TEXT
    )
  SQL
)

DB[:conn].results_as_hash = true