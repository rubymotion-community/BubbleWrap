## 0.4.0

* Refactored the code and test suite to be more modular and to handle
  dependencies. One can now require only a subset of BW such as `require 'bubble-wrap/core'` or 'bubble-wrap/http'

## 0.3.1

* Added App.run_after(delay){ }
* HTTP responses return true to ok? when the status code is 20x.

## 0.3.0

* Major refactoring preparing for 1.0: [List of commits](https://github.com/mattetti/BubbleWrap/compare/v0.2.1...v0.3.0)

## 0.2.1

* Minor fix in the way the dependencies are set (had to monkey patch
  RubyMotion)

## 0.2.0

* Added network activity notification to the HTTP wrapper.
* fixed a bug in the `NSNotificationCenter` wrapper.

## 0.1.2

Start packaging this lib as a gem.
