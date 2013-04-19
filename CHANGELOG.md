## Unreleased

## 1.2.0.pre

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.2...master)

* Added `BW::UIBarButtonItem`, a factory-esque wrapper for `UIBarButtonItem` ([#202](https://github.com/rubymotion/BubbleWrap/pull/202))
* Added `BW::Font`, a wrapper for creating `UIFont` objects ([#206](https://github.com/rubymotion/BubbleWrap/pull/206))
* Added `BW::Reactor::Eventable#off`, to remove `BW::Reactor` callbacks ([#205](https://github.com/rubymotion/BubbleWrap/pull/205))
* Added `BW::Constants.get`, which is a class to help wrapper creation ([#203](https://github.com/rubymotion/BubbleWrap/pull/203))
* Added `BW::Location.get_once` to grab only one location ([#197](https://github.com/rubymotion/BubbleWrap/pull/197))
* Added `App#environment`, to detect the current RubyMotion environment ([#191](https://github.com/rubymotion/BubbleWrap/pull/191))
* Added `:follow_urls` option to `BW::HTTP` ([#192](https://github.com/rubymotion/BubbleWrap/pull/192))
* Added `:common_modes` option to `BW::Reactor`to change the runloop mode (#190)
* Added `:no_redirect` option to `BW::HTTP` ([#187](https://github.com/rubymotion/BubbleWrap/pull/187))
* Added `:cookies` option to `BW::HTTP` ([#204](https://github.com/rubymotion/BubbleWrap/pull/204))

## 1.1.5

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.1.4...v1.1.5)

* Fix `BW::Camera` view-controller selection process to pickup a window's `presentedViewController` ([#183](https://github.com/rubymotion/BubbleWrap/pull/183))
* Fix strings parsed in `BW::JSON` to be mutable ([#175](https://github.com/rubymotion/BubbleWrap/pull/175))
* Add option for `:credential_persistence`/`NSURLCredentialPersistence` in `BW::HTTP` ([#166](https://github.com/rubymotion/BubbleWrap/pull/166))
* Change `Device.wide_screen?` to `Device.long_screen?` ([#159](https://github.com/rubymotion/BubbleWrap/pull/159))
* String escaping fixes to `BW::HTTP` ([#160](https://github.com/rubymotion/BubbleWrap/pull/160) [#161](https://github.com/rubymotion/BubbleWrap/pull/161) [#162](https://github.com/rubymotion/BubbleWrap/pull/162))
* Add `Device.sdk_version`

## 1.1.4

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.1.3...v1.1.4)

* Support RubyMotion 1.24 or above (https://github.com/rubymotion/BubbleWrap/pull/143)
* Fixed a problem with `when` events not properly handling multiple targets per event. Now defaults to one target per event with an option to append multiple targets.

## 1.1.3

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.1.2...v1.1.3)


## 1.1.2

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.1.1...v1.1.2)

* Fixed a problem with the load path.
* Added `format:` to the HTTP wrapper with [5 supported formats supported](https://github.com/rubymotion/BubbleWrap/pull/109) that sets the content type accordingly.
* Default HTTP Content-Type for `POST` like requests is back to being
  form url encoded.

## 1.1.1

[Commit history](https://github.com/rubymotion/BubbleWrap/compare/v1.1.0...v1.1.1)

### Enhancements

* Added support for symbols as selectors to the KVO module.
* Improved the RSSParser by providing a delegate to handle errors.

### Bug Fixes

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
