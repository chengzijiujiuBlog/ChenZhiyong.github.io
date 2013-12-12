---
layout: post
title: Welcome to RubyLove
subheading: A new blog about Ruby and why we love her
categories: News
author: thatrubylove
---

### Ruby is not just an OO language

#### It is much, much cooler than that

Take the following code.

```ruby
# Functional coding in Ruby - better than chunky bacon
print_to_console   = ->(msg) { puts msg }
print_to_motd_file = ->(msg) { File.write("motd.txt", msg) }

# Display the "message of the day" via the selected printer
motd  = ->(printer) {
  msg = ["Hello World,\n",
        "  Sincerely,\n",
        "  thatrubylove"].join
  printer.(msg)
}

# Echo to the console
motd.(print_to_console)

# write to a file
motd.(print_to_motd_file)
```

[View on github](https://gist.github.com/thatrubylove/7604891)

Whoa! What is going on there? Actually it is very simple, functional ruby when you understand how ruby treats lambdas. Essentially we are holding off evaluation until called.
We start off by creating a couple of macros which will be expanded when they are called, and within the context of where they were called.

Consider the first one:

```ruby
print_to_console   = ->(msg) { puts msg }
```

All I  am doing here is creating a variable and assigning it to a lambda. Lambdas are not evaluated immediately, you have to 'call' them. When this one is called, it is called with 1 argument (msg) it will then evaluate the ```puts``` statement with the msg.

But _why? you might ask. 

You might be thinking.. "We could just create a method that takes one argument and pass that argument to puts" and you would be right, sorta.

However that would make it impossible to pass that method to another method as an argument. You could wrap your method as a proc or lambda. But hold with me for a little longer.

```ruby
print_to_console   = ->(msg) { puts msg }

motd  = ->(printer) {
  msg = ["Hello World,\n",
        "  Sincerely,\n",
        "  thatrubylove"].join
  printer.(msg)
}

motd.(print_to_console)
```

So we have our ```print_to_console lambda```, and we now have another lambda, this time it takes the argument printer, then it.. umm..

```ruby
printer.(msg)
```

What kind of method call is that? 

That is a lambda function calling the lambda function that was passed into the lambda function. But why the .()?
It isn't as complicated as it looks. Ruby is quite happy to let us leave the method name out in this case, it defaults to ```call```.

```ruby
printer.(msg)
# is the same as
printer.call(msg)
```

Now if you are like me, and I know I am... then you don't want to type more than you have to to understand and read a piece of code. You also don't want to write code more than you need to. Reading code is hard, writing more code means you are writing more bugs.

Back to that motd lambda now:

```ruby
motd  = ->(printer) {
  msg = ["Hello World,\n",
        "  Sincerely,\n",
        "  thatrubylove"].join
  printer.(msg)
}

motd.(print_to_console)
```

Our lambda function takes a 'printer' which is another lambda that will handle the printing when this lambda has done it's work. Once it builds the msg string, it invokes the printer's call method, with the msg as it's args and the value at that method is our printer function!

So by passing ```print_to_console``` to ```motd``` we print the motd to the console via our lambda wrapping ```puts```. If we go back to the original code we have 2 'printers', one that prints to console, and one that writes to a file.

```ruby
print_to_console   = ->(msg) { puts msg }
print_to_motd_file = ->(msg) { File.write("motd.txt", msg) }
```

We can just swap ```print_to_motd_file``` in for ```print_to_console``` and we get the same behavior from ```motd``` but it takes that behavior and passes it along the chain to a function we specify. In this case it is a file write.

How cool is that?

### I <3 Ruby.

~ thatrubylove
