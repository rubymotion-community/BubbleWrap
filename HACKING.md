# Hacking on BubbleWrap

## A library in two parts

RubyMotion forces a certain background-radiation of schitzophrenia
due to the fact that it's build tools run using the system ruby
via Rake.  BubbleWrap manipulates the build environment in order
to make it possible to include itself (and other code) into the
build process from outsite the project heirarchy.

### Part the first: `lib/`

This is where [RubyGems](http://rubygems.org) goes looking for
code when you call

```ruby
require 'bubble-wrap'
```

When `bubble-wrap` is required it immediately requires `bubble-wrap/loader` which sets up the infrastructure needed to manipulate the `Rakefile` build process.  Once that is done we can freely call

```ruby
BubbleWrap.require 'motion/core/**/*.rb'
```

`BubbleWrap.require` (or simply `BW.require`) is used to include
library code into the Rake build process used by RubyMotion. 
`BW.require` is similar to ruby's standard `require` method with
two major changes:

  - it can take a file pattern as used by [`Dir.glob`](http://ruby-doc.org/core-1.9.3/Dir.html#method-c-glob).
  - it can be passed a block to manipulate dependencies.

If a block is passed to `BW.require` it is evaluated in the context
of `BW::Requirement` and thus has access to all it's class methods.
The most common use cases are setting file dependencies:

```ruby
BW.require('motion/core/**/*.rb') do
  file('motion/core/device/screen.rb').depends_on 'motion/core/device.rb'
end
```

and specifying frameworks that need to be included at build time:

```ruby
BW.require('motion/**/*.rb') do
  file('motion/address_book.rb').uses_framework 'Addressbook'
end
```

### Part the second: `motion/`

Inside the `motion` directory you'll see the actual implementation code
which is compiled into RubyMotion projects that are using BubbleWrap.

  - `motion/core` contains "core" extension, things that the developers
    reasonably think should be included in every BubbleWrap using project.
    Careful consideration should be taken when making changes to the 
    contents and test coverage (in `spec/core`) must be updated to match.
    This can be included in your project by requiring `bubble-wrap` or 
    `bubble-wrap/core` in your project `Rakefile`.
  - `motion/http` contains the "http" extension.  This can be included
    by requiring `bubble-wrap/http` in your project `Rakefile`.
  - `motion/test_suite_delegate` contains a simple `AppDelegate` which
    can be used to enable the `rake spec` to run when developing a
    BubbleWrap gem.  Using `require 'bubble-wrap/test'` will include
    it in the build process and also configure the app delegate to point
    to `TestSuiteDelegate`. See the [BubbleWrap gem guide](gem.html) for
    more information.

#### Your project here

If you think that your project would be of interest to the large number 
of RubyMotion users that use BubbleWrap in their daily development then
feel free to fork [the repository on GitHub](https://github.com/mattetti/BubbleWrap)
and send us a pull request.

You should place your implemenation files in a subdirectory of `motion`
(eg `motion/my_awesome_project`), your tests in a subdirectory of `spec`
(eg `spec/my_awesome_project`) and you can create a require file in
`lib/bubble-wrap` for example `lib/bubble-wrap/my_awesome_project.rb`:

```ruby
require 'bubble-wrap/loader'
BW.require 'motion/my_awesome_project.rb'
```

People will then be able to use it by adding:

```ruby
require 'bubble-wrap/my_awesome_project'
```

to their project's `Rakefile`

## Go forth and conquer!

The developers wish to thank you so much for taking the time
to improve BubbleWrap and by extension the RubyMotion
ecosystem. You're awesome!
