# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bubble-wrap/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Aimonetti", "Francis Chong"]
  gem.email         = ["mattaimonetti@gmail.com", "francis@ignition.hk"]
  gem.description   = "RubyMotion wrappers and helpers (Ruby for iOS) - Making Cocoa APIs more Ruby like, one API at a time. Fork away and send your pull request."
  gem.summary       = "RubyMotion wrappers and helpers (Ruby for iOS) - Making Cocoa APIs more Ruby like, one API at a time. Fork away and send your pull request."
  gem.homepage      = "https://github.com/mattetti/BubbleWrap"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bubble-wrap"
  gem.require_paths = ["lib"]
  gem.version       = BubbleWrap::VERSION

  gem.add_development_dependency 'rspec'
end
