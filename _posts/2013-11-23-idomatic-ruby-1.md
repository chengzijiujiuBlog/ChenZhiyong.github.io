---
layout: post
title: Idiomatic Ruby 1
subheading: You probably aren't writing ruby..
categories: howto
author: thatrubylove
---

# Idiomatic Ruby 1

OK, so you are writing IN ruby, but you probably aren't writing ruby.
You are writing c/basic in rubyish syntax. This is bad. Slap your hand
bad. Makes Matz cry bad. You should be writing in *idiomatic ruby*.

So what does this *idiomatic ruby* I speak of look like? 

What better way to present my case then by starting with some *c/basic ruby*?

```ruby
def some_long_method_with_many_problems(user, ids)
  vals = []
  ids.each do |id|
    vals << user.returns_a_hash(id)
  end

  if vals.any?
    retval = do_something_with_hashes(vals)
  else
    retval = do_something_without
  end
  retval
end
```

And then refactor it into this *idiomatic ruby* we get much different looking code. Code that is clean and neat and terse. *ruby code*!

```ruby
def some_better_method(user, ids)
  vals   = ids.map     {|id| user.returns_a_hash(id) }
  method = vals.any? ? [:do_something_with_hashes, vals] :
                       [:do_something_without]
  send(*method)
end
```

Let's start with what I would consider the *first* violation of *idiomatic ruby*, the use of a local variable to be looped over and appended to or replaced based on the outcome of the loop.

```ruby
vals = []
ids.each do |id|
  vals << user.returns_a_hash(id)
end
```

What we really have here is a *enumeration*. We are going to *enumerate* over several objects and place the return of that object method call into an array.

So instead of looping, lets *enumerate* over our collection via ```map``` and return an array.

```ruby
vals = ids.map {|id| user.returns_a_hash(id) }
```

The *second* violation to *idiomatic ruby* is the conditional code (if/else) and the 'inner' assignment of the retval.

```ruby
if vals.any?
  retval = do_something_with_hashes(vals)
else
  retval = do_something_without
end
```

To fix this we simply move the assignment:

```ruby
retval = if vals.any?
           do_something_with_hashes(vals)
         else
           do_something_without
         end
```

That is *idiomatic ruby* however if we want to take it a step further (and I always do) what we really want here is method construction. 

Also, I think the *ONLY* good conditional is a *ternary*.

So lets use *method signature construction*, a *ternary* and a *splatted method message* to accomplish the same thing.

```ruby
method = vals.any? ? [:do_something_with_hashes, vals] :
                     [:do_something_without]
send(*method)
```

Ok, this isn't too difficult, just follow me. In the first case our method takes an argument, but in the second case, no argument, just a method. 

So we build 2 arrays, one for each case. The first has a method signature and an arg, the second is just the method signature.

Then we *splat* away the array when we ```send``` it. This pattern allows us to send in multiple arguments or none to multiple methods without optional arguments that have no meaning to the method.

```ruby
def some_better_method(user, ids)
  vals   = ids.map     {|id| user.returns_a_hash(id) }
  method = vals.any? ? [:do_something_with_hashes, vals] :
                       [:do_something_without]
  send(*method)
end
```

Now that is *idiomatic ruby*. Please challenge every line of code you have to be *idiomatic, beautiful ruby* code.

~ thatrubylove
