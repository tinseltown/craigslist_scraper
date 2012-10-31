require_relative 'search_result'
require_relative 'query'
require_relative 'user'
require_relative 'clsearch_digest'


include Initializer
include CLScraper

def frequency_to_day(frequency)
  case frequency
  when 1
    [3]
  when 2
    [5, 6]
  when 3
    [1, 3, 5]
  end
end

def send_digest(url, query_id, email)
  query = Query.new(url, 1)
  results = SearchResult.from_query(query.results_data)
  results.add_to_db(query_id)
  digest = CLSearchDigest.new(results.id)
  digest.send_digest_email(email)
end

def get_email(user_id)
  sql_query = "SELECT primary_email FROM users, queries WHERE users.id = #{user_id} LIMIT 1"
  db.execute(sql_query)[0][0]
end

queries = db.execute('SELECT id, url, digest_frequency, user_id FROM queries')

queries.each do |query|
  id = query[0]
  url = query[1]
  freq = query[2]
  usr_id = query[3]

  if frequency_to_day(freq).include?(Time.now.wday)
    send_digest(url, id, get_email(usr_id))
  end
end
