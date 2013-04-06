require File.expand_path('../loader', __FILE__)
['core', 'http', 'reactor', 'rss_parser', 'ui', 'location', 'media', 'font'].each { |sub|
	require File.expand_path("../#{sub}", __FILE__)
}