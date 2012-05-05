# BubbleWrap for RubyMotion

A collection of helpers and wrappers used to wrap CocoaTouch code and provide more Ruby like APIs.

## HTTP

`BubbleWrap::HTTP` wraps `NSURLRequest`, `NSURLConnection` and friends to provide Ruby developers with a more familiar and easier to use API.
The API uses async calls and blocks to stay as simple as possible.

Usage example:

```ruby
BubbleWrap::HTTP.get("https://api.github.com/users/mattetti") do |response|
  p response.body.to_str
end
```

## JSON

`BubbleWrap::JSON` wraps `NSJSONSerialization` available in iOS5 and offers the same API as Ruby's JSON std lib.

## Kernel

A collection of useful methods used often in my RubyMotion apps.

Examples:
```ruby
> iphone?
# true
> ipad?
# false
> orientation
# :portrait
> simulator?
> true
```

## App

A module allowing developers to store global states and alos provides a
persistence layer.

## NSUserDefaults

Helper methods added to the class repsonsible for user preferences.

## NSIndexPath

Helper methods added to give `NSIndexPath` a bit more or a Ruby
interface.
