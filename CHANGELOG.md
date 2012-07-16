## 1.1.1

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.1.0...v1.1.1)

### Feature

* Added support for symbols as selectors to the KVO module.
* Improved the RSSParser by providing a delegate to handle errors.

### Bug Fix

* Fixed a bug with the way JSON payloads were handled in the HTTP
  wrapper.
* Fixed a bug with the way the headers and content types were handled in
  the HTTP wrapper.

## 1.1.0

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.0.0...v1.1.0)

* Added `BubbleWrap::Reactor`,  a simplified implementation of the Event Machine API on top of GCD.
* Added upload support to the HTTP wrapper.
* Added `BubbleWrap.create_uuid` to generate a uuid string.
* Added a program progress proc option to the HTTP wrapper.
* Added a RSS parser.
* Added a camera wrapper.
* Split the various wrappers in self contained and requirable libraries.
* Added a wrapper around the location/gps APIs.
* Added a merge method to the persistence layer so multiple values can
  be saved at once.
* Added a way to create `UIColor` instances using a hex string: `'#FF8A19'.to_color` or color keyword: `'blue'.to_color`, `'dark_gray'.to_color`.

## 1.0.0

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v0.4.0...v1.0.0)

* Improved the integration with RubyMotion build system.
* Improved test suite.
* Added better documentation, including on how to work on the internals.
* Added a KVO DSL to observe objects.
* Renamed `Device.screen.widthForOrientation` to Device.screen.width_for_orientation` and `Device.screen.heightForOrientation` to `Device.screen.height_for_orientation`.
* The `HTTP` wrapper now encodes arrays in params in a way that's compatible with Rails.

## 0.4.0

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v0.3.1...v0.4.0)

* Refactored the code and test suite to be more modular and to handle
  dependencies. One can now require only a subset of BW such as `require 'bubble-wrap/core'` or 'bubble-wrap/http'

## 0.3.1

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v0.3.0...v0.3.1)

* Added App.run_after(delay){ }
* HTTP responses return true to ok? when the status code is 20x.

## 0.3.0

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v0.2.1...v0.3.0)

* Major refactoring preparing for 1.0

## 0.2.1

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v0.2.0...v0.2.1)

* Minor fix in the way the dependencies are set (had to monkey patch
  RubyMotion)

## 0.2.0

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v0.1.2...v0.2.0)

* Added network activity notification to the HTTP wrapper.
* fixed a bug in the `NSNotificationCenter` wrapper.

## 0.1.2

Start packaging this lib as a gem.
