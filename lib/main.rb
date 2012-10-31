require './query'
require './search_result'

include CLScraper

query = Query.new("http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=macbook+pro&catAbb=sss")
results = SearchResult.from_query(query.results_data)
results.postings.each { |post| puts post.title }

