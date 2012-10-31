require '../init'
require 'mail'

class CLSearchDigest

  attr_reader :posted_on, :title, :price, :location, :category, :query_url

  include Initializer
  ########## last scrape datetime ???

  def posting_posted_on
    @posted_on = Initializer::db.execute('SELECT posted_on FROM postings WHERE search_result_id = 1')
  end

  def posting_title
    @title = Initializer::db.execute('SELECT title FROM postings WHERE search_result_id = 1')
  end

  def posting_price
    @price = Initializer::db.execute('SELECT price FROM postings WHERE search_result_id = 1')
  end

  def posting_location
    @location = Initializer::db.execute('SELECT location FROM postings WHERE search_result_id = 1')
  end

  def posting_category
    @category = Initializer::db.execute('SELECT category FROM postings WHERE search_result_id = 1')
  end

  def posting_query_url
    @query_url = Initializer::db.execute('SELECT url FROM postings WHERE search_result_id = 1')
  end

  def print_index(index)
    index_printable = (index + 1).to_s
    index_printable = "\s" + index_printable until index_printable.length == 3
    index_printable
  end


  def digest_body
    digest_body_string = ""
    0.upto(posted_on.length - 1) do |index|
      digest_body_string << "#{print_index(index)}) #{posted_on[index].first} - #{title[index].first} - #{price[index].first} "
      digest_body_string << "(#{location[index].first}) #{category[index].first} | #{query_url[index].first}\n"
    end
    digest_body_string
  end

end