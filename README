# BubbleWrap for RubyMotion

A collection of wrappers used to wrap CocoaTouch code and provide more Ruby like APIs.

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

`BubbleWrap::JSON` wraps `NSJSONSerialization` available in iOS5 and offer the same API as Ruby's json std lib.

## Kernel

A collection of useful methods used often in RubyMotion apps.
