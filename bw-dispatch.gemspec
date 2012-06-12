# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bw-dispatch/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["James Harton"]
  gem.email         = ["james@sociable.co.nz"]
  gem.description   = %q{Event loop bubblewrapper}
  gem.summary       = %q{A bubblewrapper for GCD using common Ruby idioms}
  gem.homepage      = "https://github.com/jamesotron/bw-dispatch"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bw-dispatch"
  gem.require_paths = ["lib"]
  gem.version       = BW::Dispatch::VERSION

  gem.add_dependency 'bubble-wrap'
  gem.add_development_dependency 'rake'
end
