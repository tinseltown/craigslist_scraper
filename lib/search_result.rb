# require 'open-uri'
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



  end

end

class Posting

  # def self.from_row_data(row_data)
  #   @data = row_data
  # end

  # def to_s
  #   "#{@data}"
  # end
end

# page = open("http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=macbook+pro&catAbb=sss")