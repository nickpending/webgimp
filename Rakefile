require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
  test.ruby_opts << "-rubygems"
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end