---
layout: post
title: Ruby Lambda Programming - Part 1
subheading: Crazy good fun with lambdas!
categories: functional
author: thatrubylove
---

Ruby Lambda Programming (I just made that up) or MatzLISP (credit:Matz) is a very un-ruby looking style of ruby using pure higher order functions to get our work done. The functions are lazy, idempotent, functional, and single purpose. Well, they are if written *correctly*. But enough of wordy nonesense, how about an example?

Now wait just a minute, my friend. Before we jump to code we need a problem to solve!!

[I present to you, a problem to solve!](http://projecteuler.net/problem=6)

For those who don't click links, here is the first part of the problem at hand:

* take a list of natural numbers (1,2,3..10)
* square each number and return the list of squares
* sum that list of numbers and get 385

So essentially the equation for that looks like:

* (1\*1)+(2\*2)+(3\*3)..+(10\*10) = 385

Ok, now we can have some code. Since this is just a single file ruby script, it might look a bit different from say, a rails file. We don't have bundler set up here, so I will need to call to gem and require to get minitest going. I will be using ruby 2.0 here out.

```ruby
gem 'minitest'
require 'minitest/autorun'

describe "sum_squares" do
  it { assert_equal 385, sum_squares.(1..10) }
end

```

So we will need an function called ```sum_squares``` and it should adhere to the requirements above in bullets. When it is called on the range of 1 to 10 it will evalute to 385. Simple right? Let's do this with a local variable bound to an anonymous function (so we cal *call* it).

"We are writing ruby here, we don't have no stinkin' anonymous functions! We have lambdas." Potato, Potaato.

```ruby
sum_squares = ->(num_list) { num_list.map {|num| num*num}.reduce(:+) }

gem 'minitest'
require 'minitest/autorun'

describe "sum_squares" do
  it { assert_equal 385, sum_squares.(1..10) }
end
```

So sum_squares is a lambda that takes a list of integers. It then creates a list of those integers squared, and then reduces that list down to a sum integer. Pretty simple right? And awesome! However there is an issue here I need to pick on. That function is doing way too many things!

In the special land of hearts and unicorns and perfect ruby code in which I live in, functions do one thing and one thing only. There are no 'bards' in my code.. So let's follow the *single responsibility principle* and *curry* our *god method* into several *primary* functions that we can then *compose* our ```sum_squares``` function from those.

I know, it is wordy..

```ruby
sum         = ->(num_list) { num_list.reduce(:+)             }
squares     = ->(num_list) { num_list.map {|num| num * num } }
sum_squares = ->(num_list) { sum.(squares.(num_list))        }
``` 

Now we have two *primary* functions, and our *composite* function, sum_squares, is based of it's *primary* functions. Think legos blocks into death stars. Or in the world of math, algebra functions :)

* Sum is a dsl function. It makes reduce lazy and readable, list in, single value out
* squares is a list translation function, list in, list out

Time to tackle the second part of the problem. Again for those who aren't following along [@ the original problem](http://projecteuler.net/problem=6):

* Sum all the numbers in the list
* Square that sum and you should get 3025

Hmm. That looks familiar in a smoking caterpillar sort of way. It is roughly the same thing we did before only in reversed order! Lets write a test.

```ruby
describe "square_sum" do
  it { assert_equal 3025, square_sum.(1..10) }
end
```

Now that we have our test in place, let's make magic happen.

We could just reverse the calling order of the functions right? Well, not quite. ```squares``` expects a list and after the sum we will have a single result. So we have to make a design decision. Here are the options:

* Modify sum to return [sum]
* Add a new method to do the single value version of square.

I am going to opt for the second, because I want building blocks right? Let's do a quick refactor on what he have:

```ruby
sum         = ->(num_list) { num_list.reduce(:+)                }
square      = ->(num     ) { num * num                          }
squares     = ->(num_list) { num_list.map {|num| square.(num) } }
sum_squares = ->(num_list) { sum.(squares.(num_list))           }
square_sum  = ->(num_list) { square.(sum.(num_list))            }
```

We now have another *primary* function, ```square```, and squares becomes a *composite*.

Here is the final product with gusto!

```ruby
sum         = ->(num_list) { num_list.reduce(:+)                }
square      = ->(num     ) { num * num                          }
squares     = ->(num_list) { num_list.map {|num| square.(num) } }
sum_squares = ->(num_list) { sum.(squares.(num_list))           }
square_sum  = ->(num_list) { square.(sum.(num_list))            }

describe "sum_squares" do
  it { assert_equal 385, sum_squares.(1..10) }
end

describe "square_sum" do
  it { assert_equal 3025, square_sum.(1..10) }
end
```

So there you have it. An interesting forray into functional land using ruby. We really hit on a lot of topics here briefly. Data flows, enumerations, lazy function calling, lambdas, composition, single responsiblity, and more.

Till next time, do one thing at a time, and do it explicitly.
