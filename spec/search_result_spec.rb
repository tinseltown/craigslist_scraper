require_relative '../search_result'
require 'nokogiri'
require 'vcr'
require 'open-uri'
require 'fakeweb'

include CLScraper

describe SearchResult do
  before(:each) do
    VCR.configure do |c|
      c.cassette_library_dir = 'fixtures/vcr_cassettes'
      c.hook_into :fakeweb
    end

    VCR.use_cassette('craigslist') do
      @response = open("http://sfbay.craigslist.org/search/?areaID=1&subAreaID=&query=macbook+pro&catAbb=sss")
    end

    Posting.stub(:from_row_data).and_return(true)
  end

  let(:result) { SearchResult.new }

  context "#initialize" do
    it "has postings" do
      result.postings.should_not be_nil
    end

    it "has a created_at date" do
      result.created_at.should be_an_instance_of(Time)
    end
  end

  context "#add_posting" do

    it "calls on Posting.from_row_data" do
      Posting.should_receive(:from_row_data)
      result.add_posting(@response)
    end

    it "adds a Posting object to @postings" do
      expect { result.add_posting(@response) }.to change { result.postings.length }.by(1)
    end
  end

  context "#self.from_query" do

    it "returns an instance of SearchResult" do
      SearchResult.from_query(@response).should be_an_instance_of(SearchResult)
    end

    it "able to get data from the query" do
      SearchResult.from_query(@response).should_not be_nil
    end

    it "parses the data to get the posting rows" do
      SearchResult.from_query(@response)
    end
  end

end