require 'open-uri'
require '../init'
require './search_result'



module CLScraper

  class Query
    include Initializer

    attr_reader :query_url, :id

    def initialize(url, id=0)
      if valid_url?(url)
        @query_url = url
        @id = id
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

    def search_terms
      # text after "&query=" includes our terms, plus extra query parameters
      query_terms_raw = query_url.split("query=")[1]
      # text before "&"--[0]--is our terms--[1] is unneeded text
      query_terms_with_separator = query_terms_raw.split("&")[0]
      # substitute a space for the "+" separator used in url
      query_terms_pretty = query_terms_with_separator.gsub(/\+/, "\s")
    end

    def add_to_db(user_id)
      db.execute <<-SQL
      INSERT INTO queries
      ('url', 'search_terms', 'user_id', 'created_at', 'updated_at')
      VALUES ("#{query_url}", "#{search_terms}", "#{user_id}", DATETIME('now'), DATETIME('now'))
      SQL
      set_query_id
    end

    def set_query_id
      @id = db.execute("SELECT MAX(id) FROM queries")[0][0]
    end

  end
end

query = CLScraper::Query.new("http://sfbay.craigslist.org/search/ccc?query=roller+skates&catAbb=sss&srchType=A")
query.add_to_db(2)
search = CLScraper::SearchResult.from_query(query.results_data)
search.add_to_db(query.id)