require File.expand_path('../loader', __FILE__)
['core', 'http', 'reactor', 'rss_parser', 'ui', 'location', 'media', 'wrappers'].each { |sub|
	require File.expand_path("../#{sub}", __FILE__)
}