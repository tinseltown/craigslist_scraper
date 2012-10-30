module CLScraper

  class Posting
    attr_reader :posted_on, :price, :location, :category, :url, :title

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

    def set_date!(date_data_node)
      @posted_on = date_data_node.content.strip + " #{Time.now.year}"
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

# db creation and population
    def create_postings_table
      @db.execute <<-SQL
      CREATE TABLE "postings" (
      id integer, auto_increment, primary key,
      posted_on varchar(100),
      price varchar(100),
      location varchar(250),
      category varchar(100),
      url varchar(250),
      title varchar(250),
      search_result_id, integer,
      created_at, DATETIME,
      updated_at, DATETIME,
      FOREIGN KEY (search_result_id) REFERENCES search_results(id)
      )
      SQL
    end

    def postings_to_db_fields
      count = 0
      @postings.each do |posting|
        count += 1
        @db.execute <<-SQL
        INSERT INTO postings
        VALUES ("#{count}",  "#{posting.posted_on}", "#{posting.price}",
        "#{posting.location}", "#{posting.category}", "#{posting.url}",
        "#{posting.title}", ); # foreign key needs to go here...check syntax, and created_at and updated_at
        SQL
    end

  end

end