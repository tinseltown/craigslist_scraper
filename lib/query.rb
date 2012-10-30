require 'open-uri'

module CLScraper
  class Query
    attr_accessor :query_url

    def initialize(url)
      if valid_url?(url)
        @query_url = url
      else
        raise "invalid URL"
      end
    end

    def results_data
      open(query_url)
    end

    def valid_url?(url_to_validate)
      is_valid = url_to_validate =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
      is_valid == nil ? false : true
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

    def add_queries_to_db
      @db.execute <<-SQL
      INSERT INTO queries
      ('url', 'search_terms', 'user_id', 'created_at', 'updated_at')
      VALUES ("#{url}", "#{search_terms}", "#{user_id}", DATETIME('now'), DATETIME('now'))
      SQL
    end

    def save_queries
      @postings.add_search_results_to_db
    end
  end
end

# query = CLScraper::Query.new("http://www.google.com")
# results_data = query.results_data.class
# query.results_data
# scott = CLScraper::Query.new("htp://sdf.c")
# p scott.query_url