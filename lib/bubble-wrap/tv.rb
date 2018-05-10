# This is 'all' for tvOS
require File.expand_path('../loader', __FILE__)
[
  'core',
  'location',
  'motion',
  'network-indicator',
  'reactor',
  'rss_parser',
].each { |sub|
	require File.expand_path("../#{sub}", __FILE__)
}
