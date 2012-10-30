module CLScraper

  class SearchResult
    attr_reader :postings, :created_at

    def initialize
      @postings = []
      @created_at = Time.now
    end

    def self.from_query(result_data_file)
      result = self.new


      doc = Nokogiri::HTML(result_data_file)
      postings = doc.css('.row')
      postings.each { |row| result.add_posting(row) }

      result
    end

    def add_posting(row)
      @postings << Posting.from_row_data(row)
    end

  end

end

class Posting
end