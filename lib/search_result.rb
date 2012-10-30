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
