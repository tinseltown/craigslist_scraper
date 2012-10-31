require_relative 'search_result'
require_relative 'query'
require_relative 'user'
require_relative 'clsearch_digest'

include Initializer
include CLScraper

def get_id(email)
  sql_query = "SELECT primary_email FROM users WHERE primary_email = '#{email}'"
  if db.execute(sql_query).empty?
    user = User.new(email)
    user.add_to_db
    id = user.id
  else
    sql_query = "SELECT id FROM users WHERE primary_email = '#{email}'"
    id = db.execute(sql_query)[0][0]
  end
  id
end

url = ARGV[0]
email = ARGV[1]
count = ARGV[2]
id = get_id(email)

query = Query.new(url, count)
query.add_to_db(id)
results = SearchResult.from_query(query.results_data)
results.add_to_db(query.id)

# #Email the digest
digest = CLSearchDigest.new(results.id)
digest.send_digest_email(email)






