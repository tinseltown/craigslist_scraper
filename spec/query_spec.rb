require 'rspec'
require 'open-uri'
require '../lib/query.rb'

module CLScraper
  describe Query do

# ````query_url = "http://www.yahoo.com"
    let(:query) { Query.new("http://sfbay.craigslist.org/search/ccc?query=roller+skates&catAbb=sss&srchType=A") }

    context 'when the user passes in a valid URL representing a craigslist search' do
      describe '#initialize(query_as_url)' do
        it 'returns an instance of Query' do
          query.should be_an_instance_of(Query)
        end

        it 'raises an error if an invalid URL is passed to #intialize' do
          expect { Query.new("hpp:/nogood") }.to raise_error
        end
      end

      describe '#results_data' do
        it 'stores the search results page as a file object' do
          query.results_data.should_not be nil
        end

        it 'returns a File object representing the search results' do
          query.results_data.should have_at_least(1).item
        end
      end

      describe '#valid_url?' do
        it 'returns false for an invalid url' do
          # invalid_url = "htp:/baddy"
          query.valid_url?("htp:/baddy").should be false
        end

        it 'returns true for a valid url' do
          query.valid_url?("http://google.com").should be true
        end
      end

      describe '#search_terms' do
        it 'parses out the search terms from the query_as_url, formatted as a string' do
          query.search_terms.should be_an_instance_of(String)
        end
      end
    end
  end
end
