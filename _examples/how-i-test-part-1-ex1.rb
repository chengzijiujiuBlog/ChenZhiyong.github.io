require 'json'

module JsonToBook
  extend self

  def transform(json)
    JSON.parse(json)
  end
end

require 'minitest/autorun'

describe JsonToBook do
  subject { JsonToBook }
  let(:json) {
<<EOS
    [{
      "id": "978-0641723445",
      "cat": ["book","hardcover"],
      "name": "The Lightning Thief",
      "author": "Rick Riordan",
      "series_t": "Percy Jackson and the Olympians",
      "sequence_i": 1,
      "genre_s": "fantasy",
      "inStock": true,
      "price": 12.50,
      "pages_i": 384
    }]
EOS
  }

  describe ".transform" do
    it "must return an array of book objects" do
      books_list = subject.transform(json)
      books_list.count.must_equal 1
    end
  end 
end
