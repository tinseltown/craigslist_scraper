require 'sqlite3'

module Initializer

  def db
    SQLite3::Database.new('clscraper.db')
  end

  def create_postings_table
    db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS 'postings' (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    posted_on varchar(100),
    price varchar(100),
    location varchar(250),
    category varchar(100),
    url varchar(250),
    title varchar(250),
    created_at DATETIME,
    updated_at DATETIME,
    search_result_id integer,
    FOREIGN KEY (search_result_id) REFERENCES search_results(id)
    )
    SQL
  end

  def create_queries_table
     db.execute <<-SQL
     CREATE TABLE IF NOT EXISTS 'queries' (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     url varchar(300),
     search_terms varchar (200),
     digest_frequency integer,
     created_at DATETIME,
     updated_at DATETIME,
     user_id integer,
     FOREIGN KEY (user_id) REFERENCES users(id)
     )
     SQL
  end

  def create_search_result_table
   db.execute <<-SQL
   CREATE TABLE IF NOT EXISTS 'search_results' (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   created_at DATETIME,
   updated_at DATETIME,
   query_id integer,
   FOREIGN KEY (query_id) REFERENCES queries(id)
   )
   SQL
  end

  def create_users_table
    db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS 'users' (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    primary_email varchar(150),
    alt_email_1 varchar(150),
    alt_email_2 varchar(150),
    created_at DATETIME,
    updated_at DATETIME
    )
    SQL
  end

end

include Initializer

Initializer::db
Initializer::create_postings_table
Initializer::create_queries_table
Initializer::create_search_result_table
Initializer::create_users_table