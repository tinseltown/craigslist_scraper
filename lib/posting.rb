module CLScraper

  class Posting
    attr_reader :posted_on, :price, :location, :category, :url, :title
  
    def parse(data_node)
      puts class_name(data_node)
      case class_name(data_node)
      when 'itemdate'
        set_date!(data_node)
      when 'itempp'
        set_price!(data_node)
      when 'itempn'
        set_location!(data_node)
      when 'itemcg'
        set_category!(data_node)
      when 'url/title'
        set_url!(data_node)
        set_title!(data_node)
      end
    end

    def self.from_row_data(row_data)
      posting = self.new
      row_data.children.each { |data_node| posting.parse(data_node)}
      posting
    end

    def class_name(data_node)
      if data_node.attr('class') != nil
        name = data_node.attr('class')
      elsif data_node.attr('href') != nil
        name = 'url/title'
      else
        name = nil
      end
      name
    end

    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def set_date!(date_data_node)
      @posted_on = date_data_node.content.strip
    end

    def set_price!(price_data_node)
      @price = price_data_node.content.strip
    end

    def set_location!(loc_data_node)
      @location = loc_data_node.content.strip
    end

    def set_category!(cat_data_node)
      @category = cat_data_node.content.strip
    end

    def set_url!(url_title_data_node)
      @url = url_title_data_node.attr('href')
    end

    def set_title!(url_title_data_node)
      @title = url_title_data_node.content
    end

  end

end




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
 


