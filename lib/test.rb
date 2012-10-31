require '../init'

class Mail
  include Initializer
  ########## last scrape datetime
  posted_on = Initializer::db.execute('SELECT posted_on FROM postings WHERE search_result_id = 1')
  title = Initializer::db.execute('SELECT title FROM postings WHERE search_result_id = 1')
  price = Initializer::db.execute('SELECT price FROM postings WHERE search_result_id = 1')
  location = Initializer::db.execute('SELECT location FROM postings WHERE search_result_id = 1')
  category = Initializer::db.execute('SELECT category FROM postings WHERE search_result_id = 1')
  url = Initializer::db.execute('SELECT url FROM postings WHERE search_result_id = 1')

  def print_index(index)
    index_printable = (index + 1).to_s
    index_printable = "\s" + index_printable until index_printable.length == 3
    index_printable
  end


  string = ""
  0.upto(posted_on.length - 1) do |index|
    string << "#{print_index(index)}) #{posted_on[index].first} - #{title[index].first} - #{price[index].first} "
    string << "(#{location[index].first}) #{category[index].first} | #{url[index].first}\n"
  end

  puts string

end