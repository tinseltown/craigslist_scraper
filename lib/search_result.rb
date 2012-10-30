require './posting'
require 'nokogiri'

module CLScraper

  class SearchResult

    attr_reader :postings, :created_at

    def initialize
      @postings = []
      @created_at = Time.now
    end

    def self.from_query(result_data_file)
      result = self.new
      Nokogiri::HTML(result_data_file).css('.row').each { |row| result.add_posting(row) }
      result
    end

    def add_posting(row)
      @postings << Posting.from_row_data(row)
    end

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

    def add_postings_to_db
      @db.execute <<-SQL
      INSERT INTO postings
      ('posted_on', 'price', 'location', 'category', 'url', 'title', 'created_at', 'updated_at', 'search_result_id')
      VALUES ("#{posted_on}", "#{price}",
      "#{location}", "#{category}", "#{url}",
      "#{title}", DATETIME('now'), DATETIME('now'), "#{search_result_id}");
      SQL
    end

    def save_postings
      postings.each { |posting| posting.add_postings_to_db }
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

    def add_search_results_to_db
      @db.execute <<-SQL
      INSERT INTO search_results
      ('query_id', 'created_at', 'updated_at')
      VALUES ("#{query_id}", DATETIME('now'), DATETIME('now'))
      SQL
    end

    def save_search_results
      @postings.add_search_results_to_db
    end
  end
end
