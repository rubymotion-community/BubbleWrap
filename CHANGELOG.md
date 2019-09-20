## Unreleased

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.9.7...master)

## 1.9.7

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.9.6...v1.9.7)

* [iOS] Fix iOS 11 photo library crash ([#493](https://github.com/rubymotion-community/BubbleWrap/pull/493))
* [iOS] Updated Device.simulator? to work in iOS 13+ ([#499](https://github.com/rubymotion-community/BubbleWrap/pull/499))
* [iOS] Add MobileCoreServices to list of required frameworks. Fixes issue with missing KUTTypeMovie constant.

## 1.9.6

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.9.5...v1.9.6)

* [iOS] Add Device.force_touch? ([#478](https://github.com/rubymotion-community/BubbleWrap/pull/478))
* [iOS] Fixes for iOS 10 ([#489](https://github.com/rubymotion-community/BubbleWrap/pull/489))

## 1.9.5

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.9.4...v1.9.5)

* Fixed 'simulator?' so it returns the correct value, when running ios 8 or below on device. ([#481](https://github.com/rubymotion-community/BubbleWrap/pull/481))

## ~~1.9.3~~ 1.9.4

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.9.2...v1.9.4)

* Fixed `Device.simulator?` for iOS 9. ([#473](https://github.com/rubymotion-community/BubbleWrap/pull/473))

## 1.9.2

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.9.1...v1.9.2)

* Added `DependentDeferrable`. ([#469](https://github.com/rubymotion-community/BubbleWrap/pull/469))

## 1.9.1

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.9.0...v1.9.1)

* Fix issue in loading iOS 8 constants for CoreLocation

## 1.9.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.8.0...v1.9.0)

* Add support for `keyboardType` on first input field of `BW::UIAlertView` ([#406](https://github.com/rubymotion-community/BubbleWrap/pull/406))
* Implement #+ and #- for NSIndexPath to incr/decr row ([#420](https://github.com/rubymotion-community/BubbleWrap/pull/420))
* Extract CoreMotion classes to make it easier to use and more maintainable ([#454](https://github.com/rubymotion-community/BubbleWrap/pull/454))
* Motion extract classes ([#454](https://github.com/rubymotion-community/BubbleWrap/pull/454))
* Added RSS fields: creator, category, encoded  ([#461](https://github.com/rubymotion-community/BubbleWrap/pull/461))
* KVO `observe!` and ability to pass multiple key paths to `observe` ([#460](https://github.com/rubymotion-community/BubbleWrap/pull/460))
* `App.short_version` ([#466](https://github.com/rubymotion-community/BubbleWrap/pull/466))
* Bump the required version of iOS to >= 7 ([#424](https://github.com/rubymotion-community/BubbleWrap/pull/424))
* Bump the required version of iOS to >= 7 ([#424](https://github.com/rubymotion-community/BubbleWrap/pull/424))
* Fixes to CoreLocation ([#422](https://github.com/rubymotion-community/BubbleWrap/pull/422)) & ([#432](https://github.com/rubymotion-community/BubbleWrap/pull/432))
* Adds default text option to BW::UIAlertView ([#467](https://github.com/rubymotion-community/BubbleWrap/pull/467))
* Bump the minimum required RubyMotion version to `3.12`.

## ... nothing to see here... move along.

## 1.4.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.3.0...v1.4.0)

* Added `BW::Mail` for sending emails ([#247](https://github.com/rubymotion-community/BubbleWrap/pull/247))
* Added `BW::SMS` for sending SMS/iMessages ([#287](https://github.com/rubymotion-community/BubbleWrap/pull/287))
* Added `App::Persistence.delete` ([#286](https://github.com/rubymotion-community/BubbleWrap/pull/286))
* Added `BW::HTTP::Response#error`, which is an `NSError` instance ([#284](https://github.com/rubymotion-community/BubbleWrap/pull/284))
* Added `BW::HTTP::Query#cancel` to chancel URL requests ([#278](https://github.com/rubymotion-community/BubbleWrap/pull/278))
* Added `App.info_plist` ([#273](https://github.com/rubymotion-community/BubbleWrap/pull/273/))
* Added `BW::Device.interface_orientation` ([#265](https://github.com/rubymotion-community/BubbleWrap/pull/265))
* Added `OPTIONS` request method to `BW::HTTP` ([#260](https://github.com/rubymotion-community/BubbleWrap/pull/260))
* Added `Time.iso8601_with_timezone` ([#255](https://github.com/rubymotion-community/BubbleWrap/pull/255))
* Added `:encoding` option to `BW::HTTP` ([#251](https://github.com/rubymotion-community/BubbleWrap/pull/251))
* Moved `BW::Reactor::Timer` and `BW::Reactor::PeriodicTimer` from `NSTimer` to GCD `Dispatch::Source.timer` ([#242](https://github.com/rubymotion-community/BubbleWrap/pull/242))
	* Option `:common_modes` for BW::Reactor::PeriodicTimer has been deprecated, it's not needed anymore.
* Fixed App#window (and thus `BW::Camera`) to work with iOS7 modals ([#305](https://github.com/rubymotion-community/BubbleWrap/pull/305))
* Fixed patches on `String` to be on `NSString` ([#292](https://github.com/rubymotion-community/BubbleWrap/pull/292))
* Fixed `BW::HTTP` success heuristic to match RFC 2616 ([#282](https://github.com/rubymotion-community/BubbleWrap/pull/282))
* Fixed `BW::HTTP` to correctly identify `false` parameters ([#261](https://github.com/rubymotion-community/BubbleWrap/issues/261) [#262](https://github.com/rubymotion-community/BubbleWrap/pull/262))
* Fixed `BW::Reactor` to correctly handle unregistered procs ([#253](https://github.com/rubymotion-community/BubbleWrap/pull/253))
* Fixed `BW::localized_string` to mirror Cocoa API by returning the `key` if no localization exists ([#181](https://github.com/rubymotion-community/BubbleWrap/pull/181))
* Addressed a few memory related problems ([#270](https://github.com/rubymotion-community/BubbleWrap/pull/270) [#275](https://github.com/rubymotion-community/BubbleWrap/pull/275) [#276](https://github.com/rubymotion-community/BubbleWrap/pull/276))

## 1.3.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.2.0...v1.3.0)

* Added OS X support for RubyMotion 2.0 ([#233](https://github.com/rubymotion-community/BubbleWrap/pull/233)). BubbleWrap *drops support* for RubyMotion 1.x.
* Changed `BW::UIBarButtonItem` internals; `.build` is now deprecated and forwards to `.new` ([#226](https://github.com/rubymotion-community/BubbleWrap/pull/226))
* Changed `HTTP` to present credentials with an `Authorization` header *before* any requests are made, unless the `:present_credentials` option `== false` ([#199](https://github.com/rubymotion-community/BubbleWrap/pull/199))
* Fixed `HTTP` to not append a question-mark (`?`) at the end of URL requests with empty `:payload`s ([#221](https://github.com/rubymotion-community/BubbleWrap/pull/221))
* Fixed `HTTP` to correctly parameterize an array of hashes, Rails-style ([#219](https://github.com/rubymotion-community/BubbleWrap/pull/219))

## 1.2.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.1.5...v1.2.0)

* Added `BW::UIBarButtonItem`, a factory-esque wrapper for `UIBarButtonItem` ([#202](https://github.com/rubymotion-community/BubbleWrap/pull/202))
* Added `BW::Font`, a wrapper for creating `UIFont` objects ([#206](https://github.com/rubymotion-community/BubbleWrap/pull/206))
* Added `BW::Reactor::Eventable#off`, to remove `BW::Reactor` callbacks ([#205](https://github.com/rubymotion-community/BubbleWrap/pull/205))
* Added `BW::Constants.get`, which is a class to help wrapper creation ([#203](https://github.com/rubymotion-community/BubbleWrap/pull/203))
* Added `BW::Location.get_once` to grab only one location ([#197](https://github.com/rubymotion-community/BubbleWrap/pull/197))
* Added `App#environment`, to detect the current RubyMotion environment ([#191](https://github.com/rubymotion-community/BubbleWrap/pull/191))
* Added `:follow_urls` option to `BW::HTTP` ([#192](https://github.com/rubymotion-community/BubbleWrap/pull/192))
* Added `:common_modes` option to `BW::Reactor`to change the runloop mode (#190)
* Added `:no_redirect` option to `BW::HTTP` ([#187](https://github.com/rubymotion-community/BubbleWrap/pull/187))
* Added `:cookies` option to `BW::HTTP` ([#204](https://github.com/rubymotion-community/BubbleWrap/pull/204))

## 1.1.5

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.1.4...v1.1.5)

* Fix `BW::Camera` view-controller selection process to pickup a window's `presentedViewController` ([#183](https://github.com/rubymotion-community/BubbleWrap/pull/183))
* Fix strings parsed in `BW::JSON` to be mutable ([#175](https://github.com/rubymotion-community/BubbleWrap/pull/175))
* Add option for `:credential_persistence`/`NSURLCredentialPersistence` in `BW::HTTP` ([#166](https://github.com/rubymotion-community/BubbleWrap/pull/166))
* Change `Device.wide_screen?` to `Device.long_screen?` ([#159](https://github.com/rubymotion-community/BubbleWrap/pull/159))
* String escaping fixes to `BW::HTTP` ([#160](https://github.com/rubymotion-community/BubbleWrap/pull/160) [#161](https://github.com/rubymotion-community/BubbleWrap/pull/161) [#162](https://github.com/rubymotion-community/BubbleWrap/pull/162))
* Add `Device.sdk_version`

## 1.1.4

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.1.3...v1.1.4)

* Support RubyMotion 1.24 or above (https://github.com/rubymotion-community/BubbleWrap/pull/143)
* Fixed a problem with `when` events not properly handling multiple targets per event. Now defaults to one target per event with an option to append multiple targets.

## 1.1.3

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.1.2...v1.1.3)


## 1.1.2

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.1.1...v1.1.2)

* Fixed a problem with the load path.
* Added `format:` to the HTTP wrapper with [5 supported formats supported](https://github.com/rubymotion-community/BubbleWrap/pull/109) that sets the content type accordingly.
* Default HTTP Content-Type for `POST` like requests is back to being
  form url encoded.

## 1.1.1

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.1.0...v1.1.1)

### Enhancements

* Added support for symbols as selectors to the KVO module.
* Improved the RSSParser by providing a delegate to handle errors.

### Bug Fixes

* Fixed a bug with the way JSON payloads were handled in the HTTP
  wrapper.
* Fixed a bug with the way the headers and content types were handled in
  the HTTP wrapper.

## 1.1.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v1.0.0...v1.1.0)

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

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v0.4.0...v1.0.0)

* Improved the integration with RubyMotion build system.
* Improved test suite.
* Added better documentation, including on how to work on the internals.
* Added a KVO DSL to observe objects.
* Renamed `Device.screen.widthForOrientation` to Device.screen.width_for_orientation` and `Device.screen.heightForOrientation` to `Device.screen.height_for_orientation`.
* The `HTTP` wrapper now encodes arrays in params in a way that's compatible with Rails.

## 0.4.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v0.3.1...v0.4.0)

* Refactored the code and test suite to be more modular and to handle
  dependencies. One can now require only a subset of BW such as `require 'bubble-wrap/core'` or 'bubble-wrap/http'

## 0.3.1

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v0.3.0...v0.3.1)

* Added App.run_after(delay){ }
* HTTP responses return true to ok? when the status code is 20x.

## 0.3.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v0.2.1...v0.3.0)

* Major refactoring preparing for 1.0

## 0.2.1

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v0.2.0...v0.2.1)

* Minor fix in the way the dependencies are set (had to monkey patch
  RubyMotion)

## 0.2.0

[Commit history](https://github.com/rubymotion-community/BubbleWrap/compare/v0.1.2...v0.2.0)

* Added network activity notification to the HTTP wrapper.
* fixed a bug in the `NSNotificationCenter` wrapper.

## 0.1.2

Start packaging this lib as a gem.
