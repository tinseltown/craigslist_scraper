require_relative '../search_result'
require 'nokogiri'
require 'fakeweb'
include CLScraper

describe SearchResult do
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
    before(:each) do
      Posting.stub(:from_row_data).and_return(true)
    end

    it "calls on Posting.from_row_data" do
      Posting.should_receive(:from_row_data)
      result.add_posting("row")
    end

    it "adds a Posting object to @postings" do
      expect { result.add_posting("row") }.to change { result.postings.length }.by(1)
    end
  end

  context "#self.from_query" do
    before(:each) do
      FakeWeb.register_uri(:get, "http://craigslist.com/mysearch", :body => "Posting")

      Nokogiri.stub!(:HTML).and_return(@file)
    end

    it "returns an instance of SearchResult" do
      SearchResult.from_query("data").should be_an_instance_of(SearchResult)
    end

    it "able to get data from the query" do
      SearchResult.from_query("data").should_not be_nil
    end

    it "parses the data to get the posting rows"

    it "passes each row to add_posting"
  end

end