require File.expand_path('../loader', __FILE__)
[
  'core',
  'font',
  'http',
  'location',
  'mail','sms',
  'media',
  'motion',
  'network-indicator',
  'reactor',
  'rss_parser',
  'ui',
].each { |sub|
	require File.expand_path("../#{sub}", __FILE__)
}
