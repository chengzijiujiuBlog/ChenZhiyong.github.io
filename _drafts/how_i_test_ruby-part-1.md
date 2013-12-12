---
layout: post
title: How I Test Ruby - Part 1
subheading: Starting small, staying focused, automating
categories: News
author: thatrubylove
---

I will start out with a confession. I hate rspec. It's not the syntax
or the *idea* of BDD. It's the sheer size and complexity of the library.

One of the guiding principles I live by is smaller is better. I try to
build ruby apps without a lot of dependencies. I try to keep things
small and organized. Testing is no different.

## So what DO you use to test ruby?

MiniSpec.

MiniSpec is small, it is part of MiniTest, which is baked into ruby
these days. When Ryan designed this library, he got it right. (Not
unusual for the zenspider) It is light-weight and can accomlish *good*
testing without a lot of fuss.

## What is *good* testing?

When I am 'smell testing' tests I look for a few things:

* Is it expressive?
* Is it focused?
* Does it test outside it's boundaries? (unit)
* Does it mock outside it's boundaries?
* Does the test reflect the implementation?

Instead of explaining each of these, which are mostly intuative anyway,
I will jump right into test driving a new feature that will take a json
repsonse and return a list of ruby objects that consumed the json. To
be valid, a json 'record' must have all the attributes filled in.

```ruby
require 'minitest/autorun'

describe JsonToBook do
  subject { JsonToBook }
  let(:json) {
<<EOS
    [
      "id" : "978-0641723445",
      "cat" : ["book","hardcover"],
      "name" : "The Lightning Thief",
      "author" : "Rick Riordan",
      "series_t" : "Percy Jackson and the Olympians",
      "sequence_i" : 1,
      "genre_s" : "fantasy",
      "inStock" : true,
      "price" : 12.50,
      "pages_i" : 384
    }]
EOS
  }

  describe ".transform" do
    it "must return an array of book objects" do
      books_list = subject.transform(json)
      books_list[0].cat.must_equal %w(book hardcover)
      books_list[0].id.must_equal "978-0641723445"
    end
  end 
end
```

Let's take this a step at a time.

I do a curl against the json endpoint to get a sample of real data. That
becomes a string assigned to the variable json in my test.

To get a simple pass without dealing with comparision of objects, I
look at the first item in the transformed list, and then verify a few
values.

Now I run the file, which runs the tests. I use vim, so I mapped
<Leader>+space to run the current file I am on.

I get failing tests, because all I have here is a test. There is no
implementation yet. Let's fix that. Same file.

```ruby
module JsonToBook
  extend self

  def transform(json)
    json.map
  end

end

require 'minitest/autorun'
...
```
