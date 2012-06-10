# Getting Started with BubbleWrap

A short guide to starting a RubyMotion application using the bubble wrappers.

## A quick note about RubyMotion

[RubyMotion](http://www.rubymotion.com/) is a commercial product available from
[HipByte SPRL](http://www.hipbyte.com/). RubyMotion needs a recent (10.6 or newer)
version of Mac OS X and Apple's Xcode tools installed. If you don't have a working
RubyMotion install take a look at the [getting started guide](http://www.rubymotion.com/developer-center/guides/getting-started/).

## Create a new RubyMotion project

RubyMotion ships with the `motion` command-line tool to handle creating projects,
updating and creatint support tickets.

```
$ motion create bw-demo
    Create bw-demo
    Create bw-demo/.gitignore
    Create bw-demo/Rakefile
    Create bw-demo/app
    Create bw-demo/app/app_delegate.rb
    Create bw-demo/resources
    Create bw-demo/spec
    Create bw-demo/spec/main_spec.rb
```

This gives us an empty project (and one failing spec).  That's fine for now.

## Set up Bundler

[Bundler](http://www.gembundler.com/) is a project to manage your project's
RubyGem dependencies. You can get by without it if you want to, but it will
save time and hassle as the number of BubbleWrap gems grows over time.

```
$ gem install bundler
```

Create a new file called `Gemfile` in your project directory and add the
following:

```ruby
source :rubygems
gem 'bubble-wrap', '~> 1.0.0'
gem 'rake'
```

Then run `bundle` from the command-line in the same directory and Bundler
should install BubbleWrap and Rake for you.


## Adding BubbleWrap

Now that we have BubbleWrap installed we need to configure the project to use
it - the easiest way is to add Bundler to our build-environment and tell it 
to take care of everything for us.

Edit your project's `Rakefile` and add the following just under `require 'motion/project'`:

```ruby
require 'bundler'
Bundler.setup
Bundler.require
```

Now when you build your project by running `rake` you will see the BubbleWrap files
being compiled into your project.

## Customising BubbleWrap requires

By default BubbleWrap will include all the bubble wrappers into your project, but often
you won't need them all - perhaps you only want to use BubbleWrap's `http` wrappers?
You can change your bubble-wrap line in your `Gemfile` as follows:

```ruby
gem 'bubble-wrap', '~> 1.0.0', :require => 'bubble-wrap/http'
```

If you just want core, the change is similarly easy:

```ruby
gem 'bubble-wrap', '~> 1.0.0', :require => 'bubble-wrap/core'
```

Also, if you don't want any of BubbleWrap loaded by default, and you just want to use
it's ability to add projects to your build system you can change it to:

```ruby
gem 'bubble-wrap', '~> 1.0.0', :require => 'bubble-wrap/loader'
```

And modify your `Rakefile` to include one or more `BW.require` lines:

```ruby
BW.require '/path/to/some/files/**/*.rb'
```

For more information in using `BW.require` take a look at
[the bubblewrap hacking guide](http://bubblewrap.io/hacking.html).

## Go forth and conquer!

The developers wish to thank you for using BubbleWrap.
Please feel free to open issues or pull requests on 
[GitHub](https://www.github.com/mattetti/BubbleWrap), join our
[mailing list](https://groups.google.com/forum/#!forum/bubblewrap)
or join us on `#bubblewrap` on `irc.freenode.net`.
