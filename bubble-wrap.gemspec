# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bubble-wrap/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Matt Aimonetti', 'Francis Chong', 'James Harton', 'Clay Allsopp', 'Dylan Markow', 'Jan Weinkauff', 'Marin Usalj']
  gem.email         = ['mattaimonetti@gmail.com', 'francis@ignition.hk', 'james@sociable.co.nz', 'clay.allsopp@gmail.com', 'dylan@dylanmarkow.com', 'jan@dreimannzelt.de', 'marin2211@gmail.com']
  gem.description   = 'RubyMotion wrappers and helpers (Ruby for iOS and OS X) - Making Cocoa APIs more Ruby like, one API at a time. Fork away and send your pull request.'
  gem.summary       = 'RubyMotion wrappers and helpers (Ruby for iOS and OS X) - Making Cocoa APIs more Ruby like, one API at a time. Fork away and send your pull request.'
  gem.homepage      = 'https://github.com/rubymotion-community/BubbleWrap'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|lib_spec|features)/})
  gem.name          = 'bubble-wrap'
  gem.require_paths = ['lib']
  gem.version       = BubbleWrap::VERSION

  gem.extra_rdoc_files = gem.files.grep(%r{motion})

  gem.add_development_dependency 'mocha', '~> 0.11'
  gem.add_development_dependency 'mocha-on-bacon', '~> 0.2'
  gem.add_development_dependency 'bacon', '~> 1.2'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'webstub', '~> 1.1'
  gem.add_development_dependency 'motion-provisioning'

end
