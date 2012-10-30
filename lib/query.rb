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

  end
end

# query = CLScraper::Query.new("http://www.google.com")
# results_data = query.results_data.class
# query.results_data
# scott = CLScraper::Query.new("htp://sdf.c")
# p scott.query_url