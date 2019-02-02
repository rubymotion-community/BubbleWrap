# BubbleWrap for RubyMotion

A collection of (tested) helpers and wrappers used to wrap Cocoa Touch and AppKit code and provide more Ruby like APIs.

[BubbleWrap website](http://rubymotion.github.io/BubbleWrap/)
[BubbleWrap mailing list](https://groups.google.com/forum/#!forum/bubblewrap)

[![Code Climate](https://codeclimate.com/github/rubymotion/BubbleWrap.svg)](https://codeclimate.com/github/rubymotion/BubbleWrap)
[![Build Status](https://travis-ci.org/rubymotion/BubbleWrap.svg?branch=master)](https://travis-ci.org/rubymotion/BubbleWrap)
[![Gem Version](https://badge.fury.io/rb/bubble-wrap.png)](http://badge.fury.io/rb/bubble-wrap)
[![Dependency Status](https://gemnasium.com/rubymotion/BubbleWrap.png)](https://gemnasium.com/rubymotion/BubbleWrap)

## Installation

```ruby
gem install bubble-wrap
```

## Setup

1. Edit the `Rakefile` of your RubyMotion project and add the following require line:

```ruby
require 'bubble-wrap'
```

If you use Bundler:

```ruby
gem 'bubble-wrap', '~> 1.9.6'
```

BubbleWrap is split into multiple modules so that you can easily choose which parts are included at compile-time.

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

If you wish to only include the `Mail` wrapper:

```ruby
require 'bubble-wrap/mail'
```

If you wish to only include the `SMS` wrapper:

```ruby
require 'bubble-wrap/sms'
```

If you wish to only include the `Motion` (CoreMotion) wrapper:

```ruby
require 'bubble-wrap/motion'
```

If you wish to only include the `NetworkIndicator` wrapper:

```ruby
require 'bubble-wrap/network-indicator'
```

If you want to include everything (ie kitchen sink mode) you can save time and do:

```ruby
require 'bubble-wrap/all'
```

You can also do this directly in your `Gemfile` like so:

```ruby
gem 'bubble-wrap', require: %w[bubble-wrap/core bubble-wrap/location, bubble-wrap/reactor]
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
'#88FF8A19'.to_color # ARGB format
=> #<UIDeviceRGBColor:0xca0fe00>
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
> App.alert("BubbleWrap is awesome!", {cancel_button_title: "I know it is!", message: "Like, seriously awesome."})
# creates and shows an alert message with optional parameters.
> App.run_after(0.5) {  p "It's #{Time.now}"   }
# Runs the block after 0.5 seconds.
> App.open_url("http://matt.aimonetti.net")
> App.open_url("tel://123456789")
# Opens the url using the device's browser. Can also open custom URL schemas (accepts a string url or an instance of `NSURL`.)
> App.can_open_url("tel://")
# Returns whether the app can open a given URL resource.
> App::Persistence['channels'] # application specific persistence storage
# ['NBC', 'ABC', 'Fox', 'CBS', 'PBS']
> App::Persistence['channels'] = ['TF1', 'France 2', 'France 3']
# ['TF1', 'France 2', 'France 3']
> App.environment
# 'test'
```

Other available methods:

* `App.notification_center`
* `App.user_cache`
* `App.states`
* `App.frame`
* `App.delegate`
* `App.shared`
* `App.window`
* `App.current_locale`
* `App.release?`
* `App.test?`
* `App.development?`


### Device

A collection of useful methods about the current device:

Examples:

```ruby
> Device.iphone?
# true
> Device.ipad?
# false
> Device.camera.front?
# true
> Device.camera.rear?
# true
> Device.orientation
# :portrait
> Device.interface_orientation
# :portrait
> Device.simulator?
# true
> Device.ios_version
# "6.0"
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
> Device.vendor_identifier
# <NSUUID>
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

# Lets the user edit the photo (with access to the edited and original photos)
BW::Device.camera.any.picture(allows_editing: true, media_types: [:image]) do |result|
  edited_image_view = UIImageView.alloc.initWithImage(result[:edited_image])
  original_image_view = UIImageView.alloc.initWithImage(result[:original_image])
end

# Capture a low quality movie with a limit of 10 seconds
BW::Device.camera.front.picture(media_types: [:movie], video_quality: :low, video_maximum_duration: 10) do |result|
  video_file_path = result[:media_url]
end
```

Options include:

- `:allows_editing` - Boolean; whether a user can edit the photo/video before picking
- `:animated` - Boolean; whether to display the camera with an animation (default true)
- `:on_dismiss` - Lambda; called instead of the default dismissal logic
- `:media_types` - Array; containing any of `[:movie, :image]`
- `:video_quality` - Symbol; one of `:high`, `:medium`, `low`, `"640x480".to_sym`, `iframe1280x720`, or `iframe960x540`. Defaults to `:medium`
- `:video_maximum_duration` - Integer; limits movie recording length. Defaults to 600.

### JSON

`BW::JSON` wraps `NSJSONSerialization` available in iOS5 and offers the same API as Ruby's JSON std lib. For apps building for iOS4, we suggest a different JSON alternative, like [AnyJSON](https://github.com/mattt/AnyJSON).

```ruby
BW::JSON.generate({'foo' => 1, 'bar' => [1,2,3], 'baz' => 'awesome'})
=> "{\"foo\":1,\"bar\":[1,2,3],\"baz\":\"awesome\"}"
BW::JSON.parse "{\"foo\":1,\"bar\":[1,2,3],\"baz\":\"awesome\"}"
=> {"foo"=>1, "bar"=>[1, 2, 3], "baz"=>"awesome"}
```

### NSIndexPath

Helper methods added to give `NSIndexPath` a bit more of a Ruby
interface.

```ruby
index_path = table_view.indexPathForCell(cell)
index_path + 1 # NSIndexPath for next cell in the same section
=> #<NSIndexPath:0x120db8e0>
```

### NSNotificationCenter

Helper methods to give NSNotificationCenter a Ruby-like interface:

```ruby
def viewWillAppear(animated)
  @foreground_observer = App.notification_center.observe UIApplicationWillEnterForegroundNotification do |notification|
    loadAndRefresh
  end

  @reload_observer = App.notification_center.observe 'ReloadNotification' do |notification|
    loadAndRefresh
  end
end

def viewWillDisappear(animated)
  App.notification_center.unobserve @foreground_observer
  App.notification_center.unobserve @reload_observer
end

def reload
  App.notification_center.post 'ReloadNotification'
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
> App::Persistence.delete('channels')
# ['TF1', 'France 2', 'France 3']
> App::Persistence['something__new'] # something previously never stored
# nil
> App::Persistence.all
# {'all':'values', 'stored':'by', 'bubblewrap':'as a hash!'}
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

You can remove observers using `unobserve` method.

**Since: > version 1.9.0**

Optionally, multiple key paths can be passed to the `observer` method:

``` ruby
class ExampleViewController < UIViewController
  include BW::KVO

  def viewDidLoad
    @label = UILabel.alloc.initWithFrame [[20,20],[280,44]]
    @label.text = ""
    view.addSubview @label

    observe(@label, [:text, :textColor]) do |old_value, new_value, key_path|
      puts "Hello from viewDidLoad for #{key_path}!"
    end
  end
end
```

Also you can use `observe!` method to register observer that will immediately
return initial value. Note that in this case only new value will be passed to
the block.


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

Interface for Ruby-like GPS and compass access (the CoreLocation framework):

```ruby
> BW::Location.enabled? # Whether location services are enabled on the device
=> true
> BW::Location.authorized? # If your app is authorized to use location services
=> false
```

```ruby
BW::Location.get(purpose: 'We need to use your GPS because...') do |result|
  p "From Lat #{result[:from].latitude}, Long #{result[:from].longitude}"
  p "To Lat #{result[:to].latitude}, Long #{result[:to].longitude}"
end
```
*Note: `result[:from]` will return `nil` the first time location services are started.*

The `:previous` key in the `BW::Location.get()` result hash will always return an array of zero or more additional `CLLocation` objects aside from the locations returned from the `:to` and `:from` hash keys.  While in most scenarios this array will be empty, per [Apple's Documentation](https://developer.apple.com/library/IOs/documentation/CoreLocation/Reference/CLLocationManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/CLLocationManagerDelegate/locationManager:didUpdateLocations:) if there are deferred updates or multiple locations that arrived before they could be delivered, multiple locations will be returned in an order of oldest to newest.


```ruby
BW::Location.get_compass do |result|
  p result[:magnetic_heading] # Heading towards magnetic north
  p result[:true_heading] # Heading towards true north
  p result[:accuracy] # Potential error between magnetic and true heading
  p result[:timestamp] # Timestamp of the heading calculation
end
```

`BW::Location.get_significant` is also available, for monitoring significant location changes.

`BW::Location` also supports `get_once`-style methods, which will return the first result before ending the search:

```ruby
BW::Location.get_once(desired_accuracy: :three_kilometers, ...) do |result|
  if result.is_a?(CLLocation)
    p result.coordinate.latitude
    p result.coordinate.longitude
  else
    p "ERROR: #{result[:error]}"
  end
end

BW::Location.get_compass_once do |heading|
  p result[:magnetic_heading]
  p result[:true_heading]
  p result[:accuracy]
  p result[:timestamp]
end
```

### iOS 8 Location Requirements

iOS 8 introduced stricter location services requirements. Although BubbleWrap will handle most of this for you automatically, you are required to add a few key/value pairs to the `Info.plist`. Add these two lines to your `Rakefile` (with your descriptions, obviously):

```ruby
app.info_plist['NSLocationAlwaysUsageDescription'] = 'Description'
app.info_plist['NSLocationWhenInUseUsageDescription'] = 'Description'
```

*Note: you need both keys to use `get_once`, so it's probably best to just include both no matter what.* See [Apple's documentation](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW18) on iOS 8 location services requirements for more information.

## Motion

Interface for the accelerometer, gyroscope, and magnetometer sensors (the
CoreMotion framework).  You can access each sensor individually, or you can get
data from all of them at once using the `BW::Motion.device` interface, which
delegates to `CMMotionManager#deviceMotion`.

Each sensor has an `every` and `once` method. `every` expects a time interval,
and you will need to retain the object it returns and call `#stop` on it when
you are done with the data.

The `every` and `once` methods can accept a `:queue` option. The default value
is a queue that runs on the main loop, so that UI updates can be processed in
the block. This is useful, but not recommended by Apple, since the events can
come in at a high rate. If you want to use a background queue, you can either
specify an NSOperationQueue object, or you can use one of these symbols:

- `:main` - `NSOperationQueue.mainQueue`, this is the default value.
- `:background` - BubbleWrap will create a new `NSOperationQueue`.
- `:current` - BubbleWrap will use `NSOperationQueue.currentQueue`.

If you pass a string instead, a new queue will be created and its `name`
property will be set to that string.

The `CMDeviceMotion` interface (`BW::Motion.device`) accepts a `:reference`
option, which specifies the `CMAttitudeReferenceFrame`.  The default value is
the same as the one that `CMMotionManager` uses, which is returned by the
`CMMotionManager#attitudeReferenceFrame` method.  This option should be passed
to the `repeat`, `every` or `once` methods.

###### Accelerometer
```ruby
BW::Motion.accelerometer.available?
BW::Motion.accelerometer.data  # returns CMAccelerometerData object or nil

# ask the CMMotionManager to update every 5 seconds
BW::Motion.accelerometer.every(5) do |result|
  # result contains the following data (from CMAccelerometerData#acceleration):
  p result[:data]  # the CMAccelerometerData object
  p result[:acceleration]  # the CMAcceleration struct
  p result[:x]  # acceleration in the x direction
  p result[:y]  #          "          y direction
  p result[:z]  #          "          z direction
end

# every, start, and repeat all need to be stopped later.
BW::Motion.accelerometer.stop

# repeat, but don't set the interval
BW::Motion.accelerometer.repeat do |result|
end

# you can specify a :queue where the operations will be executed.  See above for details
BW::Motion.accelerometer.every(5, queue: :background) { |result| ... }
BW::Motion.accelerometer.every(5, queue: :main) { |result| ... }
BW::Motion.accelerometer.every(5, queue: :current) { |result| ... }
BW::Motion.accelerometer.every(5, queue: 'my queue') { |result| ... }

BW::Motion.accelerometer.once do |result|
  # ...
end
```

###### Gyroscope
```ruby
BW::Motion.gyroscope.available?
BW::Motion.gyroscope.data  # returns CMGyroData object or nil

# ask the CMMotionManager to update every second.
BW::Motion.gyroscope.every(1) do |result|
  # result contains the following data (from CMGyroData#rotationRate):
  p result[:data]  # the CMGyroData object
  p result[:rotation]  # the CMRotationRate struct
  p result[:x]  # rotation in the x direction
  p result[:y]  #        "        y direction
  p result[:z]  #        "        z direction
end
BW::Motion.gyroscope.stop

BW::Motion.gyroscope.once do |result|
  # ...
end
```

###### Magnetometer
```ruby
BW::Motion.magnetometer.available?
BW::Motion.magnetometer.data  # returns CMMagnetometerData object or nil

# ask the CMMotionManager to update every second
BW::Motion.magnetometer.every(1) do |result|
  # result contains the following data (from CMMagnetometerData#magneticField):
  p result[:data]  # the CMMagnetometerData object
  p result[:field]  # the CMMagneticField struct
  p result[:x]  # magnetic field in the x direction
  p result[:y]  #           "           y direction
  p result[:z]  #           "           z direction
end
BW::Motion.magnetometer.stop

BW::Motion.magnetometer.once do |result|
  # ...
end
```

###### Device Motion

This is an amalgam of all the motion sensor data.

```ruby
BW::Motion.device.available?
BW::Motion.device.data  # returns CMDeviceMotion object or nil

BW::Motion.device.every(1) do |result|
  # result contains the following data:
  p result[:data]  # the CMDeviceMotion object
  # orientation data, from CMDeviceMotion#attitude
  p result[:attitude]  # the CMAttitude struct
  p result[:roll]
  p result[:pitch]
  p result[:yaw]
  # rotation data, from CMDeviceMotion#rotationRate
  p result[:rotation]  # the CMRotationRate struct
  p result[:rotation_x]
  p result[:rotation_y]
  p result[:rotation_z]
  # gravity+acceleration vector, from CMDeviceMotion#gravity
  p result[:gravity]  # the CMAcceleration struct
  p result[:gravity_x]
  p result[:gravity_y]
  p result[:gravity_z]
  # just the acceleration vector, from CMDeviceMotion#userAcceleration
  p result[:acceleration]  # the CMAcceleration struct
  p result[:acceleration_x]
  p result[:acceleration_y]
  p result[:acceleration_z]
  # the magnetic data, from CMDeviceMotion#magneticField
  p result[:magnetic]  # the CMCalibratedMagneticField struct
  p result[:magnetic_field]  # the CMMagneticField struct from the CMCalibratedMagneticField
  p result[:magnetic_x]
  p result[:magnetic_y]
  p result[:magnetic_z]
  p result[:magnetic_accuracy]  # this will be a symbol, :low, :medium, :high, or nil if the magnetic data is uncalibrated

  # less useful data from CMAttitude, unless you're into the whole linear algebra thing:
  p result[:matrix]  # CMAttitude#rotationMatrix
  p result[:quarternion]  # CMAttitude#quarternion
end

# the reference frame should be one of the CMAttitudeReferenceFrame constants...
ref = CMAttitudeReferenceFrameXArbitraryZVertical
# ... or one of these symbols: :arbitrary_z, :corrected_z, :magnetic_north, :true_north
ref = :corrected_z
BW::Motion.device.every(1, queue: :background, reference: ref) { |result| ... }

BW::Motion.device.once do |result|
  # ...
end
```

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

## Mail

Wrapper for showing an in-app mail composer view.

You should always determine if the device your app is running on is configured to send mail before displaying a mail composer window. `BW::Mail.can_send_mail?` will return `true` or `false`.

```ruby
# Opens as a modal in the current UIViewController
BW::Mail.compose(
  delegate: self, # optional, defaults to rootViewController
  to: [ "tom@example.com" ],
  cc: [ "itchy@example.com", "scratchy@example.com" ],
  bcc: [ "jerry@example.com" ],
  html: false,
  subject: "My Subject",
  message: "This is my message. It isn't very long.",
  animated: false,
  attachments: [
    {data: nsdata-object, mime_type: "mime/type", file_name: "file.name"},
    ...
  ]
) do |result, error|
  result.sent?      # => boolean
  result.canceled?  # => boolean
  result.saved?     # => boolean
  result.failed?    # => boolean
  error             # => NSError
end
```

## SMS

Wrapper for showing an in-app message (SMS) composer view.

You should always determine if the device your app is running on can send SMS messages before displaying a SMS composer window. `BW::SMS.can_send_sms?` will return `true` or `false`.

```ruby
# Opens as a modal in the current UIViewController
    BW::SMS.compose (
    {
       delegate: self, # optional, will use root view controller by default
       to: [ "1(234)567-8910" ],
       message: "This is my message. It isn't very long.",
       animated: false
    }) {|result, error|
       result.sent?      # => boolean
       result.canceled?  # => boolean
       result.failed?    # => boolean
       error             # => NSError
      }
```

## NetworkIndicator

Wrapper for showing and hiding the network indicator (the status bar spinner).

```ruby
    BW::NetworkIndicator.show  # starts the spinner
    BW::NetworkIndicator.hide  # stops it

    # the nice thing is if you call 'show' multiple times, the 'hide' method will
    # not have any effect until you've called it the same number of times.
    BW::NetworkIndicator.show
    # ...somewhere else
    BW::NetworkIndicator.show

    # ...down the line
    BW::NetworkIndicator.hide
    # indicator is still visible

    BW::NetworkIndicator.hide
    # NOW the indicator is hidden!

    # If you *really* want to hide the indicator immediately, you can call `reset!`
    # but this is in no way encouraged.
    BW::NetworkIndicator.reset!

    # and for completeness, a check to see if the indicator is visible
    BW::NetworkIndicator.visible?
```

## UI

### Gestures

Extra methods on `UIView` for working with gesture recognizers. A gesture recognizer can be added using a normal Ruby block, like so:

```ruby
    view.when_tapped do
      UIView.animateWithDuration(1,
        animations:lambda {
          # animate
          # @view.transform = ...
        })
    end
```

There are similar methods for `pinched`, `rotated`, `swiped`, `panned`, and `pressed` (for long presses). All of the methods return the actual recognizer object, so it is possible to set the delegate if more fine-grained control is needed.

In order to prevent retain cycles due to strong references within the passed block, use the use_weak_callbacks flag so the blocks do not retain a strong reference to self:

```ruby
BubbleWrap.use_weak_callbacks = true
```

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

The `#when` method also accepts bitwise combinations of events:

```ruby
button.when(UIControlEventTouchUpInside | UIControlEventTouchUpOutside) do
  self.view.backgroundColor = UIColor.redColor
end
```

You can use symbols for events (but won't work with the bitwise operator):

```ruby
button.when(:touch_up_inside) do
  self.view.backgroundColor = UIColor.redColor
end

button.when(:value_changed) do
  self.view.backgroundColor = UIColor.blueColor
end
```

Set the use_weak_callbacks flag so the blocks do not retain a strong reference to self:

```ruby
BubbleWrap.use_weak_callbacks = true
```

### UIBarButtonItem

`BW::UIBarButtonItem` is a subclass of `UIBarButtonItem` with an natural Ruby syntax.

#### Constructors

Instead specifying a target-action pair, each constructor method accepts an optional block.  When the button is tapped, the block is executed.

```ruby
BW::UIBarButtonItem.system(:save) do
  # ...
end

title = "Friends"
BW::UIBarButtonItem.styled(:plain, title) do
  # ...
end

image = UIImage.alloc.init
BW::UIBarButtonItem.styled(:bordered, image) do
  # ...
end

image     = UIImage.alloc.init
landscape = UIImage.alloc.init
BW::UIBarButtonItem.styled(:bordered, image, landscape) do
  # ...
end

view = UIView.alloc.init
BW::UIBarButtonItem.custom(view) do
  # ...
end
# NOTE: The block is attached to the view as a single tap gesture recognizer.
```

The `.new` constructor provides a flexible, builder-style syntax.

```ruby
options = { :system => :save }
BW::UIBarButtonItem.new(options) do
  # ...
end

options = { :styled => :plain, :title => "Friends" }
BW::UIBarButtonItem.new(options) do
  # ...
end

options = { :styled => :bordered, :image => UIImage.alloc.init }
BW::UIBarButtonItem.new(options) do
  # ...
end

options = {
  :styled    => :bordered,
  :image     => UIImage.alloc.init,
  :landscape => UIImage.alloc.init
}
BW::UIBarButtonItem.new(options) do
  # ...
end

options = { :custom => UIView.alloc.init }
BW::UIBarButtonItem.new(options) do
  # ...
end
# NOTE: The block is attached to the view as a single tap gesture recognizer.
```

#### Button types

The `.styled` button types are:

```ruby
:plain
:bordered
:done
```

And the `.system` button types are:

```ruby
:done
:cancel
:edit
:save
:add
:flexible_space
:fixed_space
:compose
:reply
:action
:organize
:bookmarks
:search
:refresh
:stop
:camera
:trash
:play
:pause
:rewind
:fast_forward
:undo
:redo
:page_curl
```

### UIActivityViewController

`BW::UIActivityViewController` is a subclass of `UIActivityViewController` with an natural Ruby syntax.

You can initiate a `UIActivityViewController` with or without a completion handler block. For more information on `UIActivityViewController`s, see [Apple's documentation](https://developer.apple.com/library/ios/documentation/uikit/reference/UIActivityViewController_Class/Reference/Reference.html).

```ruby
# Without a completion handler
BW::UIActivityViewController.new(
  items: "Some Text", # or ["Some Text", NSURL.URLWithString('http://www.rubymotion.com')] or a UIImage
  animated: true, # Defaults to true
  excluded: :add_to_reading_list # One item or an array
)

# With completion handler
BW::UIActivityViewController.new(
  items: "Some Text",
  animated: true,
  excluded: [:add_to_reading_list, :print, :air_drop]
) do |activity_type, completed|
  puts "completed with activity: #{activity_type} - finished?: #{completed}"
end
```

Built in activities that can be passed to the `excluded` option are defined as `UIActivity` class `UIActivityType` constants:

```ruby
:post_to_facebook
:post_to_twitter
:post_to_weibo
:message
:mail
:print
:copy_to_pasteboard
:assign_to_contact
:save_to_camera_roll
:add_to_reading_list
:post_to_flickr
:post_to_vimeo
:post_to_tencent_weibo
:air_drop
```

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
feed_parser.parse do |item|
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

def when_parser_errors
  p "The parser encountered an error"
  ns_error = feed_parser.parserError
  p ns_error.localizedDescription
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

`BW::Reactor` is a simplified, mostly complete implementation of
the [Event Machine](http://rubyeventmachine.com/) API.  In fact
`BW::Reactor` is aliased to `EM` in the runtime environment.

### Deferables

BubbleWrap provides both a `Deferrable` mixin and a `DefaultDeferrable`
class, which simply mixes in deferrable behaviour if you don't want to
implement your own.

A deferrable is an object with four states: unknown, successful, failure
and timeout.  When you initially create a deferrable it is in an unknown
state, however you can assign callbacks to be run when the object
changes to either successful or failure state.

Using `delegate`, `errback_delegate` and `callback_delegate` you can link
deferrables together.

By default, callbacks will be made on the thread that the deferrable
succeeds/fails on. For multithreaded environments, it can be useful to use
EM::ThreadAwareDeferrable so that callbacks will be made on the threads they
are declared on.

#### Success

```ruby
> d = EM::DefaultDeferrable.new
=> #<BW::Reactor::DefaultDeferrable:0x6d859a0>
> d.callback { |what| puts "Great #{what}!" }
=> [#<Proc:0x6d8a1e0>]
> d.succeed "justice"
Great justice!
=> nil
```

#### Failure

```ruby
> d = EM::DefaultDeferrable.new
=> #<BW::Reactor::DefaultDeferrable:0x8bf3ee0>
> d.errback { |what| puts "Great #{what}!" }
=> [#<Proc:0x8bf3ef0>]
> d.fail "sadness"
Great sadness!
=> nil
```
#### Delegate

```ruby
> d = EM::DefaultDeferrable.new
=> #<BW::Reactor::DefaultDeferrable:0x8bf3ee0>
> delegate = EM::DefaultDeferrable.new
=> #<BW::Reactor::DefaultDeferrable:0x8bf5910>
> d.delegate delegate
=> #<BW::Reactor::DefaultDeferrable:0x8bf3ee0>
> delegate.callback { |*args| puts args }
=> [#<Proc:0x8bf3ef0>]
> d.succeed :passed
=> nil
=> [:passed]
```

#### DependentDeferrable

`DependentDeferrable` depends on children deferrables. A `DependentDeferrable`
succeeds only when every child succeeds and fails immediately when any child
fails

```ruby
> d1 = EM::DefaultDeferrable.new
=> #<BubbleWrap::Reactor::DefaultDeferrable:0x10c713750>
> d2 = EM::DefaultDeferrable.new
=> #<BubbleWrap::Reactor::DefaultDeferrable:0x10370bb10>
> d = EM::DependentDeferrable.on(d1, d2)
=> #<BubbleWrap::Reactor::DependentDeferrable:0x106c17b80>
> d.callback {|a, b| puts "a: #{a} b: #{b}"}
=> [#<Proc:0x103075210>]
> d1.succeed 'one', 'one more'
> d2.succeed :two
a: ["one", "one more"] b: [:two]
```

#### ThreadAwareDeferrable

```ruby
> d = EM::ThreadAwareDeferrable.new
=> #<BW::Reactor::ThreadAwareDeferrable:0x8bf3ee0>

> queue = Dispatch::Queue.new(:deferrable.to_s)
> queue.async do
>   d.callback do |*args|
>     Dispatch::Queue.current == queue
>     => true # this is normally false
>   end
> end
> d.succeed true
```

#### Timeout

```ruby
> d = EM::DefaultDeferrable.new
=> #<BW::Reactor::DefaultDeferrable:0x8bf5910>
> d.errback { puts "Great scott!" }
=> [#<Proc:0x8bf6350>]
> d.timeout 2
=> #<BW::Reactor::Timer:0x6d920a0 @timer=#<__NSCFTimer:0x6d91990>>
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
event triggering behaviour. `BW::Reactor` uses this
behind the scenes in several places, and as it's a very handy
idiom it is available as a public API.

```ruby
> o = Class.new { include EM::Eventable }.new
=> #<#<Class:0xab63f00>:0xab64430>
> o.on(:november_5_1955) { puts "Ow!" }
=> [#<Proc:0xad9bf00>]
> flux = proc{ puts "Flux capacitor!" }
=> #<Proc:0xab630f0>
> o.on(:november_5_1955, &flux)
=> [#<Proc:0xad9bf00>, #<Proc:0xab630f0>]
> o.trigger(:november_5_1955)
Ow!
Flux capacitor!
=> [nil, nil]
> o.off(:november_5_1955, &flux)
=> #<Proc:0xab630f0>
> o.trigger(:november_5_1955)
Ow!
=> [nil]
> o.on(:november_5_1955) { puts "Ow!" }
> o.on(:november_5_1955) { puts "Another Ow!" }
> o.off(:november_5_1955)
=> nil
```

# Contributing

Do you have a suggestion for a specific wrapper? Feel free to open an
issue/ticket and tell us about what you are after. If you have a
wrapper/helper you are using and are thinking that others might enjoy,
please send a pull request with tests. If you need help writing the tests,
send the pull request anyways and we'll try to help you out with that.

1. Create an issue in GitHub to make sure your PR will be accepted
2. Fork the BubbleWrap repository
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Write tests for your changes and ensure they pass locally (`bundle exec rake spec && bundle exec rake spec osx=true`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
