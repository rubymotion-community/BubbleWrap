# Require motion-support before we mess with the build system
require 'motion-support/inflector'
# Prefix its files before BW's files.
require 'bubble-wrap/requirement'
BubbleWrap::Requirement.prefix_files(Motion::Project::App.config.files)

require 'bubble-wrap/loader'
BubbleWrap.require('motion/core.rb')
BubbleWrap.require('motion/core/**/*.rb') do
  file('motion/core/pollute.rb').depends_on 'motion/core/ns_index_path.rb'
end
require 'bubble-wrap/camera'
require 'bubble-wrap/ui'