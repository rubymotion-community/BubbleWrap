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
    alert("Login failed") # helper provided by the kernel file in this repo.
  else
    alert(response.error_message)
  end
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
# true
> documents_path
# "/Users/mattetti/Library/Application Support/iPhone Simulator/5.0/Applications/EEC6454E-1816-451E-BB9A-EE18222E1A8F/Documents"
```

## App

A module allowing developers to store global states and also provides a
persistence layer.

## NSUserDefaults

Helper methods added to the class repsonsible for user preferences.

## NSIndexPath

Helper methods added to give `NSIndexPath` a bit more or a Ruby
interface.
