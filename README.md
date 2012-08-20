# BubbleWrap for RubyMotion

A collection of (tested) helpers and wrappers used to wrap CocoaTouch code and provide more Ruby like APIs.

[BubbleWrap website](http://bubblewrap.io)
[BubbleWrap mailing list](https://groups.google.com/forum/#!forum/bubblewrap)

## Installation

```ruby
gem install bubble-wrap
```

## Setup

1. Edit the `Rakefile` of your RubyMotion project and add the following require line:

```ruby
require 'bubble-wrap'
```

BubbleWrap is split into multiple modules so that you can easily choose which parts
are included at compile-time.

The above example requires the `core` and `http` modules. If you wish to only
include the core modules use the following line of code instead:

```ruby
require 'bubble-wrap/core'
```

If you wish to only include the `HTTP` wrapper:

```ruby
require 'bubble-wrap/http'
```

If you wish to only include the `RSS Parser` wrapper:

```ruby
require 'bubble-wrap/rss_parser'
```

If you wish to only include the `Reactor` wrapper:

```ruby
require 'bubble-wrap/reactor'
```

If you wish to only include the UI-related wrappers:

```ruby
require 'bubble-wrap/ui'
```

If you wish to only include the `Camera` wrapper:

```ruby
require 'bubble-wrap/camera'
```

If you wish to only include the `Location` wrapper:

```ruby
require 'bubble-wrap/location'
```

If you wish to only include the `Media` wrapper:

```ruby
require 'bubble-wrap/media'
```

If you want to include everything (ie kitchen sink mode) you can save time and do:

```ruby
require 'bubble-wrap/all'
```


Note: **DON'T** use `app.files =` in your Rakefile to set up your files once you've required BubbleWrap.
Make sure to append onto the array or use `+=`.

2. Now, you can use BubbleWrap extension in your app:

```ruby
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    puts "#{App.name} (#{App.documents_path})"
    true
  end
end
```

Note: You can also vendor this repository but the recommended way is to
use the versioned gem.


## Core

### Misc

UUID generator:
```ruby
BubbleWrap.create_uuid
=> "68ED21DB-82E5-4A56-ABEB-73650C0DB701"
```

Localization (using `NSBundle.mainBundle.localizedStringForKey`):
```ruby
BubbleWrap.localized_string(:foo, 'fallback')
=> "fallback"
```

Color conversion:
```ruby
BubbleWrap.rgba_color(23, 45, 12, 0.4)
=> #<UIDeviceRGBColor:0x6db6ed0>
BubbleWrap.rgb_color(23, 45, 12)
=> #<UIDeviceRGBColor:0x8ca88b0>
'blue'.to_color
=> #<UICachedDeviceRGBColor:0xda535c0>
'dark_gray'.to_color
=> #<UICachedDeviceWhiteColor:0x8bb5be0>
'#FF8A19'.to_color
=> #<UIDeviceRGBColor:0x8d54110>
```

Debug flag:
```ruby
BubbleWrap.debug?
=> false
BubbleWrap.debug = true
=> true
BubbleWrap.debug?
=> true
```

### App

A module with useful methods related to the running application

```ruby
> App.documents_path
# "/Users/mattetti/Library/Application Support/iPhone Simulator/5.0/Applications/EEC6454E-1816-451E-BB9A-EE18222E1A8F/Documents"
> App.resources_path
# "/Users/mattetti/Library/Application Support/iPhone Simulator/5.0/Applications/EEC6454E-1816-451E-BB9A-EE18222E1A8F/testSuite_spec.app"
> App.name
# "testSuite"
> App.identifier
# "io.bubblewrap.testSuite"
> App.alert("BubbleWrap is awesome!")
# creates and shows an alert message.
> App.run_after(0.5) {  p "It's #{Time.now}"   }
# Runs the block after 0.5 seconds.
> App.open_url("http://matt.aimonetti.net")
# Opens the url using the device's browser. (accepts a string url or an instance of `NSURL`.
> App::Persistence['channels'] # application specific persistence storage
# ['NBC', 'ABC', 'Fox', 'CBS', 'PBS']
> App::Persistence['channels'] = ['TF1', 'France 2', 'France 3']
# ['TF1', 'France 2', 'France 3']
```

Other available methods:

* `App.notification_center`
* `App.user_cache`
* `App.states`
* `App.frame`
* `App.delegate`
* `App.shared`
* `App.current_locale`


### Device

A collection of useful methods about the current device:

Examples:

```ruby
> Device.iphone?
# true
> Device.ipad?
# false
> Device.front_camera?
# true
> Device.rear_camera?
# true
> Device.orientation
# :portrait
> Device.simulator?
# true
> Device.retina?
# false
> Device.screen.width
# 320
> Device.screen.height
# 480
> Device.screen.width_for_orientation(:landscape_left)
# 480
> Device.screen.height_for_orientation(:landscape_left)
# 320
```

### Camera

Added interface for better camera access:

```ruby
# Uses the front camera
BW::Device.camera.front.picture(media_types: [:movie, :image]) do |result|
  image_view = UIImageView.alloc.initWithImage(result[:original_image])
end

# Uses the rear camera
BW::Device.camera.rear.picture(media_types: [:movie, :image]) do |result|
  image_view = UIImageView.alloc.initWithImage(result[:original_image])
end

# Uses the photo library
BW::Device.camera.any.picture(media_types: [:movie, :image]) do |result|
  image_view = UIImageView.alloc.initWithImage(result[:original_image])
end
```

### JSON

`BubbleWrap::JSON` wraps `NSJSONSerialization` available in iOS5 and offers the same API as Ruby's JSON std lib.

```ruby
BW::JSON.generate({'foo => 1, 'bar' => [1,2,3], 'baz => 'awesome'})
=> "{\"foo\":1,\"bar\":[1,2,3],\"baz\":\"awesome\"}"
BW::JSON.parse "{\"foo\":1,\"bar\":[1,2,3],\"baz\":\"awesome\"}"
=> {"foo"=>1, "bar"=>[1, 2, 3], "baz"=>"awesome"}
```

### NSIndexPath

Helper methods added to give `NSIndexPath` a bit more of a Ruby
interface.


### NSNotificationCenter

Helper methods to give NSNotificationCenter a Ruby-like interface:

```ruby
def viewWillAppear(animated)
  @foreground_observer = App.notification_center.observe UIApplicationWillEnterForegroundNotification do |notification|
    loadAndRefresh
  end

  @reload_observer = App.notification_center.observe ReloadNotification do |notification|
    loadAndRefresh
  end
end

def viewWillDisappear(animated)
  App.notification_center.unobserve @foreground_observer
  App.notification_center.unobserve @reload_observer
end

def reload
  App.notification_center.post ReloadNotification
end
```


### NSUserDefaults

Helper methods added to the class repsonsible for user preferences used
by the `App::Persistence` module shown below.

### Persistence

Offers a way to persist application specific information using a very
simple interface:

``` ruby
> App::Persistence['channels'] # application specific persistence storage
# ['NBC', 'ABC', 'Fox', 'CBS', 'PBS']
> App::Persistence['channels'] = ['TF1', 'France 2', 'France 3']
# ['TF1', 'France 2', 'France 3']
```

### Observers
**Since: > version 0.4**

You can observe for object's changes and trigger blocks:

``` ruby
class ExampleViewController < UIViewController
  include BW::KVO

  def viewDidLoad
	@label = UILabel.alloc.initWithFrame [[20,20],[280,44]]
	@label.text = ""
	view.addSubview @label

    observe(@label, :text) do |old_value, new_value|
      puts "Hello from viewDidLoad!"
    end
  end

  def viewDidAppear(animated)
    observe(@label, :text) do |old_value, new_value|
      puts "Hello from viewDidAppear!"
    end
  end

end
```


### String

The Ruby `String` class was extended to add `#camelize` and
`#underscore` methods.

```ruby
> "matt_aimonetti".camelize
=> "MattAimonetti"
> "MattAimonetti".underscore
=> "matt_aimonetti"
```

### Time

The `Time` Ruby class was added a class level method to convert a
iso8601 formatted string into a Time instance.

```ruby
> Time.iso8601("2012-05-31T19:41:33Z")
=> 2012-05-31 21:41:33 +0200
```

## Location

Added interface for Ruby-like GPS access:

```ruby
BW::Location.get do |result|
  p "From Lat #{result[:from].latitude}, Long #{result[:from].longitude}"
  p "To Lat #{result[:to].latitude}, Long #{result[:to].longitude}"
end
```

Also available is `BW::Location.get_significant`, for monitoring significant location changes.

## Media

Added wrapper for playing remote and local media. Available are `modal` and custom presentation styles:

```ruby
# Plays in your custom frame
local_file = NSURL.fileURLWithPath(File.join(NSBundle.mainBundle.resourcePath, 'test.mp3'))
BW::Media.play(local_file) do |media_player|
  media_player.view.frame = [[10, 100], [100, 100]]
  self.view.addSubview media_player.view
end

# Plays in an independent modal controller
BW::Media.play_modal("http://www.hrupin.com/wp-content/uploads/mp3/testsong_20_sec.mp3")
```

## UI

### Gestures

Extra methods on `UIView` for working with gesture recognizers. A gesture recognizer can be added using a normal Ruby block, like so:

```ruby
    view.whenTapped do
      UIView.animateWithDuration(1,
        animations:lambda {
          # animate
          # @view.transform = ...
        })
    end
```

There are similar methods for pinched, rotated, swiped, panned, and pressed (for long presses). All of the methods return the actual recognizer object, so it is possible to set the delegate if more fine-grained control is needed.

### UIViewController

A custom method was added to `UIViewController` to return the content
frame of a view controller.

### UIControl / UIButton

Helper methods to give `UIButton` a Ruby-like interface. Ex:

```ruby
button.when(UIControlEventTouchUpInside) do
  self.view.backgroundColor = UIColor.redColor
end
```

## HTTP

`BubbleWrap::HTTP` wraps `NSURLRequest`, `NSURLConnection` and friends to provide Ruby developers with a more familiar and easier to use API.
The API uses async calls and blocks to stay as simple as possible.

To enable it add the following require line to your `Rakefile`:
```ruby
require 'bubble-wrap/http'
```

Usage example:

```ruby
BubbleWrap::HTTP.get("https://api.github.com/users/mattetti") do |response|
  p response.body.to_str
end
```

```ruby
BubbleWrap::HTTP.get("https://api.github.com/users/mattetti", {credentials: {username: 'matt', password: 'aimonetti'}}) do |response|
  p response.body.to_str # prints the response's body
end
```

```ruby
data = {first_name: 'Matt', last_name: 'Aimonetti'}
BubbleWrap::HTTP.post("http://foo.bar.com/", {payload: data}) do |response|
  if response.ok?
    json = BubbleWrap::JSON.parse(response.body.to_str)
    p json['id']
  elsif response.status_code.to_s =~ /40\d/
    App.alert("Login failed")
  else
    App.alert(response.error_message)
  end
end
```

A `:download_progress` option can also be passed. The expected object
would be a Proc that takes two arguments: a float representing the
amount of data currently received and another float representing the
total amount of data expected.


## RSS Parser
**Since: > version 1.0.0**

The RSS Parser provides an easy interface to consume RSS feeds in an
asynchronous (non blocking) way.


```ruby
feed_parser = BW::RSSParser.new("http://feeds2.feedburner.com/sdrbpodcast")
feed_parser.parse do |item|
  # called asynchronously as items get parsed
  p item.title
end
```

The yielded RSS item is of type `RSSParser::RSSItem` and has the
following attributes:

* title
* description
* link
* guid
* pubDate
* enclosure

The item can be converted into a hash by calling `to_hash` on it.

### Delegate
**Since: > version 1.0.0**

You can also designate a delegate to the parser and implement change
state callbacks:

```ruby
feed_parser = BW::RSSParser.new("http://feeds.feedburner.com/sdrbpodcast")
feed_parser.delegate = self
feed.parse do |item|
  p item.title
end

# Delegate method
def when_parser_initializes
  p "The parser is ready!"
end

def when_parser_parses
  p "The parser started parsing the document"
end

def when_parser_is_done
  p "The feed is entirely parsed, congratulations!"
end
```

These delegate methods are optional, however, you might find the
`when_parser_is_done` callback useful if you collected all the items and
want to process all at once for instance.

### Parsing a remote content or actual data

You have the choice to initialize a parser instance with a string
representing an URL, an instance of `NSURL` or my specifying that the
passed param is some data to parse directly.

```ruby
# string representing an url:
feed_parser = BW::RSSParser.new("http://feeds2.feedburner.com/sdrbpodcast")
# a NSURL instance:
url =  NSURL.alloc.initWithString("http://matt.aimonetti.net/atom.xml")
feed_parser = BW::RSSParser.new(url)
# Some data
feed = File.read('atom.xml')
feed_parser = BW::RSSParser.new(feed, true)
```


## Reactor
**Since: > version 1.0.0**

`BubbleWrap::Reactor` is a simplified, mostly complete implementation of
the [Event Machine](http://rubyeventmachine.com/) API.  In fact
`BubbleWrap::Reactor` is aliased to `EM` in the runtime environment.

### Deferables

BubbleWrap provides both a `Deferrable` mixin and a `DefaultDeferrable`
class, which simply mixes in deferrable behaviour if you don't want to
implement your own.

A deferrable is an object with four states: unknown, successful, failure
and timeout.  When you initially create a deferrable it is in an unknown
state, however you can assign callbacks to be run when the object
changes to either successful or failure state.

#### Success

```ruby
> d = EM::DefaultDeferrable.new
=> #<BubbleWrap::Reactor::DefaultDeferrable:0x6d859a0>
> d.callback { |what| puts "Great #{what}!" }
=> [#<Proc:0x6d8a1e0>]
> d.succeed "justice"
Great justice!
=> nil
```

#### Failure

```ruby
> d = EM::DefaultDeferrable.new
=> #<BubbleWrap::Reactor::DefaultDeferrable:0x8bf3ee0>
> d.errback { |what| puts "Great #{what}!" }
=> [#<Proc:0x8bf3ef0>]
> d.fail "sadness"
Great sadness!
=> nil
```

#### Timeout

```ruby
> d = EM::DefaultDeferrable.new
=> #<BubbleWrap::Reactor::DefaultDeferrable:0x8bf5910>
> d.errback { puts "Great scott!" }
=> [#<Proc:0x8bf6350>]
> d.timeout 2
=> #<BubbleWrap::Reactor::Timer:0x6d920a0 @timer=#<__NSCFTimer:0x6d91990>>
# wait...
> Great scott!
```

### Timers

*All timers can be cancelled using `EM.cancel_timer`.*

#### One-shot timers

```ruby
> EM.add_timer 1.0 do
>   puts "Great scott!"
> end
=> 146335904
> Great scott!
```

#### Periodic timers

```ruby
> count = 0
=> 0
> timer = EM.add_periodic_timer 1.0 do
>   count = count + 1
>   puts "Great scott!"
>   (count < 10) || EM.cancel_timer(timer)
> end
=> 146046832
> Great scott!
Great scott!
Great scott!
Great scott!
Great scott!
Great scott!
Great scott!
Great scott!
Great scott!
Great scott!
```

### Scheduling operations

You can use `EM.schedule` to schedule blocks to be executed
asynchronously.  BubbleWrap deviates from the EventMachine
API here in that it also provides `EM.schedule_on_main` which
makes sure that the task is run asynchronously, but on the
application's main thread - this is necessary if you are
updating the user interface.

```ruby
> EM.schedule { puts Thread.current.object_id }
146027920
=> nil
> EM.schedule_on_main { puts Thread.current.object_id }
112222480
=> nil
```

### Deferrable operations

You can also use `EM.defer` in much the same way as `EM.schedule`
with one important difference, you can pass in a second `proc`
which will be called when the first has completed, and be passed
it's result as an argument. Just like `EM.schedule`, `EM.defer`
also has an `EM.defer_on_main` version.

```ruby
> operation = proc { 88 }
=> #<Proc:0x6d763c0>
> callback = proc { |speed| puts speed >= 88 ? "Time travel!" : "Conventional travel!" }
=> #<Proc:0x8bd3910>
> EM.defer(operation, callback)
=> nil
Time travel!
```

### Events

Although not part of the EventMachine API, BubbleWrap provides
an `Eventable` mixin for use instrumenting objects with simple
event triggering behaviour. `BubbleWrap::Reactor` uses this
behind the scenes in several places, and as it's a very handy
idiom it is available as a public API.

```ruby
> o = Class.new { include EM::Eventable }.new
=> #<#<Class:0x6dc1310>:0x6dc2ec0>
> o.on(:november_5_1955) { puts "Ow!" }
=> [#<Proc:0x6dc6300>]
> o.on(:november_5_1955) { puts "Flux capacitor!" }
=> [#<Proc:0x6dc6300>, #<Proc:0x6dc1ba0>]
> o.trigger(:november_5_1955)
Ow!
Flux capacitor!
=> [nil, nil]
```

# Suggestions?

Do you have a suggestion for a specific wrapper? Feel free to open an
issue/ticket and tell us about what you are after. If you have a
wrapper/helper you are using and are thinking that others might enjoy,
please send a pull request (with tests if possible).

