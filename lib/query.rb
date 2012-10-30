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

    def search_terms
      # text after "&query=" includes our terms, plus extra query parameters
      query_terms_raw = query_url.split("query=")[1]
      # text before "&"--[0]--is our terms--[1] is unneeded text
      query_terms_with_separator = query_terms_raw.split("&")[0]
      # substitute a space for the "+" separator used in url
      query_terms_pretty = query_terms_with_separator.gsub(/\+/, "\s")

      return query_terms_pretty
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

# query = CLScraper::Query.new("http://sfbay.craigslist.org/search/ccc?query=roller+skates&catAbb=sss&srchType=A")
# puts query.search_terms
