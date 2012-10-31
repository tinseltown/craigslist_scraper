require 'nokogiri'
require '../init'

module CLScraper

  class Posting
    include Initializer

    attr_reader :posted_on, :price, :location, :category, :url, :title
    attr_accessor :search_result_id

    def parse(data_node)
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
      row_data.children.each { |data_node| posting.parse(data_node) }
      posting
    end



    def add_to_db(search_result_id)
      db.execute <<-SQL
      INSERT INTO postings
      ('posted_on', 'price', 'location', 'category', 'url', 'title', 'created_at', 'updated_at', 'search_result_id')
      VALUES ("#{posted_on}", "#{price}",
      "#{location}", "#{category}", "#{url}",
      "#{title}", DATETIME('now'), DATETIME('now'), "#{search_result_id}")
      SQL
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

    def set_date!(date_data_node)
      @posted_on = date_data_node.content.strip + " #{Time.now.year}"
    end

    def set_price!(price_data_node)
      @price = price_data_node.content.strip
    end

    def set_location!(loc_data_node)
      @location = loc_data_node.content.strip.gsub(/\(|\)/, "")
    end

    def set_category!(cat_data_node)
      @category = cat_data_node.content.strip
    end

    def set_url!(url_title_data_node)
      @url = url_title_data_node.attr('href')
    end

    def set_title!(url_title_data_node)
      @title = url_title_data_node.content.gsub(/\"/, " ")
    end

    def create
      @posted_on = "Oct 29 2012"
      @price = "$123"
      @location = "San Francisco"
      @category = "skates"
      @url = "http://craigslist.com"
      @title = "HERRO"
    end

  end

end