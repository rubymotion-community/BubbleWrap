# Creating a RubyMotion gem with BubbleWrap

Let's say we want to develop a simple library gem that lists the
people in a user's addressbook.

Let's start by initializing an empty gem directory:

```
$ gem install bundler
$ bundle gem bw-addressbook
```

Add BubbleWrap and Rake to your gem's dependencies in `bw-addressbook.gemspec`:

```ruby
Gem::Specification.new do |gem|
  gem.add_dependency 'bubble-wrap'
  gem.add_development_dependency 'rake'
end
```

Then run `bundler`:
```
$ bundle
Fetching gem metadata from https://rubygems.org/..
Using rake (0.9.2.2) 
Installing bubble-wrap (0.4.0) 
Using bw-addressbook (0.0.1) from source at /Users/jnh/Dev/tmp/bw-addressbook 
Using bundler (1.1.4) 
Your bundle is complete! Use `bundle show [gemname]` to see where a bundled gem is installed.
```

Modify your `lib/bw-addressbook.rb` to include:

```ruby
require 'bw-addressbook/version'
BW.require 'motion/address_book.rb'
```

Edit your project's `Rakefile` to include:

```ruby
#!/usr/bin/env rake
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require "bundler/gem_tasks"
Bundler.setup
Bundler.require
require 'bubble-wrap/test'
```

At this point we should have a working RubyMotion environment able to
compile our code as we write it.

Let's start by creating a spec for our address book gem in `spec/address_book_spec.rb`:

```ruby
describe AddressBook do
  describe '.list' do
    it 'returns an Enumerable' do
      AddressBook.list.is_a?(Enumerable).should == true
    end
  end
end
```

Now if you run `rake spec` you can watch the spec fail:

```
2012-06-07 11:19:35.506 Untitled[14987:f803] *** Terminating app due to uncaught exception 'NameError', reason: 'uninitialized constant AddressBook (NameError)'
*** First throw call stack:
(0x8f6022 0x286cd6 0x140054 0x291f 0x2645 0x1)
terminate called throwing an exception
```

Let's go and define ourselves an `AddressBook` class in `motion/address_book.rb`:

```ruby
class AddressBook
end
```

You'll now get a spec failure:

```
NoMethodError: undefined method `list' for AddressBook:Class
	spec.rb:156:in `block in run_spec_block': .list - returns an Enumerable
	 4:in `execute_block'
	spec.rb:156:in `run_spec_block'
	spec.rb:171:in `run'
```

Well, we'd better go and define it then, eh?

```
class AddressBook
  def self.list
    []
  end
end
```

I'm going to leave it here for now, but you're welcome to take a look at the 
fully working demonstration project on [Github](http://github.com/jamesotron/bw-addressbook-demo).
