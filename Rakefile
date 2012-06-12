#!/usr/bin/env rake
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
require "bundler/gem_tasks"
Bundler.setup
#Bundler.require
require 'bubble-wrap/loader'
require 'bubble-wrap/test'

BW.require 'motion/**/*.rb'

Motion::Project::App.setup do |app|
  app.name = 'deferrableTestSuite'
  app.identifier = 'io.bubblewrap.deferrableTestSuite'
end
