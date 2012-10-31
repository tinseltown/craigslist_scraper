require_relative './posting'
require 'nokogiri'
require_relative '../init'

module CLScraper

  class SearchResult
    include Initializer

    attr_reader :postings, :created_at, :id

    def initialize(id=0)
      @postings = []
      @created_at = Time.now
      @id=id
    end

    def self.from_query(result_data_file)
      result = self.new
      Nokogiri::HTML(result_data_file).css('.row').each { |row| result.add_posting(row) }
      result
    end

    def add_posting(row)
      @postings << Posting.from_row_data(row)
    end

    def save_postings(search_result_id)
      @postings.each { |posting| posting.add_to_db(search_result_id) }
    end

    def add_to_db(query_id)
      db.execute <<-SQL
      INSERT INTO search_results
      ('query_id', 'created_at', 'updated_at')
      VALUES ("#{query_id}", DATETIME('now'), DATETIME('now'))
      SQL
      set_search_result_id
      save_postings(id)
    end

    def set_search_result_id
      @id = db.execute("SELECT MAX(id) FROM search_results")[0][0]
    end

  end

end