---
layout: post
title: An Exercise in Refactoring in Ruby
subheading: Using extract method and idiomatic Ruby to refactor
categories: Refactoring
author: thatrubylove
---

Today I want to examine one of my favorite refactoring patterns, Extract
Method. 

* When a method does too much or is too long? Extract method.
* When you see a conditional with an if and an else. Extract method.
* When you see a comment... EXTRACT METHOD!

## Consider the following code:

```ruby
def update
  if params[:credit_card]
    #process order
    response = @order.process(params)
    if response[:status] == "success"
      render :template => "orders/show"
    else
      render :json => response
    end
  else
    if params[:shipping_contact].size > 0  &&
params[:shipping_address].size > 0
      @order.create_shipping_contact(params[:shipping_contact],params[:shipping_address])
    end
    render :template => "orders/show"
  end
end
```

This is branch madness. Any time a method looks like a space-ship, it is
a warning sign that way too much is going on there.

Lets use some method extraction to tame this method down. We will be
creating a new method at each point of branching. We move the code
inside the branch into the new method. Then we can move the render out
of the conditional.

## Refactor #1
```ruby
def update
  render if params[:credit_card]
           process_order(params)
          else
            create_shipping_contact(params)
          end
end

def process_order(params)
  response = @order.process(params)
  if response[:status] == "success"
    { :template => "orders/show" }
  else
    { :json => response }
  end
end

def create_shipping_contact(params)
  if params[:shipping_contact].size > 0  &&
     params[:shipping_address].size > 0
    @order.create_shipping_contact(params[:shipping_contact],
                                   params[:shipping_address])
  end
  { :template => "orders/show" }
end
```

Then we clean up the if statements into nicely formatted ternaries. Any
conditional with multiple conditions will become a predicate (boolean)
method.

When we are done it looks like this:

## Refactor #2

```ruby
def update
  render params[:credit_card].present? ? process_order(params) :
                                         create_shipping_contact(params)
end

def process_order(params)
  response = @order.process(params)
  response[:status] == "success" ? { template: "orders/show" } :
                                   { json:     response      }
end

def create_shipping_contact(params)
  if has_ship_options?(params)
    @order.create_shipping_contact(params[:shipping_contact],
                                   params[:shipping_address])
  end
  { template: "orders/show"  }
end

def has_ship_options?(params)
  params[:shipping_contact].present? &&
    params[:shipping_address].present?
end
```

So what have I accomplished here? It is now a whole bunch of methods
that all depend on params. Is this really a win?

Yes, and here is why. The code after the refactor is far less complex.
Each method has a single responsibility and that is it. Each method is
self documenting.

In the end I think this version is much more readable and consice. Any 
time you see a comment in a method (not above it), that is a sign you 
need use extract method, and get happy!

What do you think? Tweet your thoughts out and tag them with #rubylove.io!
