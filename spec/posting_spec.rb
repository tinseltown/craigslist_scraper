require_relative '../lib/posting'
include CLScraper

# module CLScraper
  describe Posting do

    let(:db) { SQLite3::database.new(...) }
    describe "#save" do
      it "saves to the database" do
        posting = Posting.new(blah,blah,blah)
        posting.save
        row_id = db.execute("select last_rowid()")
        row = db.execute("select title, body from postings where id = last_insert_rowid()")
        row.first.should == ["title", "body"]
      end
    end
  end
# end
