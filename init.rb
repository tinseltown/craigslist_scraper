module Initializer

  def create_postings_table
    @db.execute <<-SQL
    CREATE TABLE 'postings' (
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
     @db.execute <<-SQL
     CREATE TABLE 'queries' (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     url varchar(300),
     search_terms varchar (200),
     created_at DATETIME,
     updated_at DATETIME,
     user_id integer,
     FOREIGN KEY (user_id) REFERENCES users(id)
     )
     SQL
  end

  def create_search_result_table
   @db.execute <<-SQL
   CREATE TABLE 'search_results' (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   created_at DATETIME,
   updated_at DATETIME,
   query_id integer,
   FOREIGN KEY (query_id) REFERENCES queries(id)
   )
   SQL
  end

end