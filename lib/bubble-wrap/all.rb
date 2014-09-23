require File.expand_path('../loader', __FILE__)
[
  'core',
  'font',
  'http',
  'location',
  'mail',
  'media',
  'motion',
  'network-indicator',
  'reactor',
  'rss_parser',
  'sms',
  'ui',
].each { |sub|
	require File.expand_path("../#{sub}", __FILE__)
}
