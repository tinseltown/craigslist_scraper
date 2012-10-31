require '../init'
require 'mail'

module CLScraper

  class CLSearchDigest

    attr_reader :posted_on, :title, :price, :location, :category, :url, :query_terms, :digest_message, :search_result_id

    include Initializer

    def initialize(result_id)
        @search_result_id = result_id
        posting_posted_on
        posting_title
        posting_price
        posting_location
        posting_category
        posting_url 
    end

    def posting_posted_on
      sql_query = "SELECT posted_on FROM postings WHERE search_result_id = #{search_result_id}"
      @posted_on = Initializer::db.execute(sql_query)
    end

    def posting_title
      sql_query = "SELECT title FROM postings WHERE search_result_id = #{search_result_id}"
      @title = Initializer::db.execute(sql_query)
    end

    def posting_price
      sql_query = "SELECT price FROM postings WHERE search_result_id = #{search_result_id}"
      @price = Initializer::db.execute(sql_query)
    end

    def posting_location
      sql_query = "SELECT location FROM postings WHERE search_result_id = #{search_result_id}"
      @location = Initializer::db.execute(sql_query)
    end

    def posting_category
      sql_query = "SELECT category FROM postings WHERE search_result_id = #{search_result_id}"
      @category = Initializer::db.execute(sql_query)
    end

    def posting_url
      sql_query = "SELECT url FROM postings WHERE search_result_id = #{search_result_id}"
      @url = Initializer::db.execute(sql_query)
    end

    def print_index(index)
      index_printable = (index + 1).to_s
      index_printable = "\s" + index_printable until index_printable.length == 3
      index_printable
    end


    def digest_body
      digest_body_string = ""
      posted_on.length.times do |index|
        digest_body_string << "#{print_index(index)}) #{posted_on[index].first} - #{title[index].first} - #{price[index].first} "
        digest_body_string << "(#{location[index].first}) #{category[index].first} | #{url[index].first}\n"
      end
      digest_body_string
    end

    def create_email(recipient_email)
      the_body = digest_body
      @digest_message = Mail.new do
        from "jeremyleejames@gmail.com"
        to "#{recipient_email}"
        subject "CraigsList Search Digest - "#{posting_query_terms}"
        body the_body
      end
    end

    def send_digest_email(recipient_email)
      digest_body
      create_email(recipient_email)
      digest_message.delivery_method :sendmail
      digest_message.deliver
    end

  end

end