#!/usr/bin/env sh

bundle install &&
bundle exec rake clean &&
bundle exec rake spec &&
bundle exec rake clean &&
bundle exec rake spec osx=true