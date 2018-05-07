# This is 'all' for for the tvOS
require File.expand_path('../loader', __FILE__)
[
  'core',
  'font',
  'location',
  'media',
  'motion',
  'network-indicator',
  'reactor',
  'rss_parser',
  'ui',
].each { |sub|
	require File.expand_path("../#{sub}", __FILE__)
}
