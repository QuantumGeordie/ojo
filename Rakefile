require 'rake'
require 'rake/testtask'
require "bundler/gem_tasks"

require 'ojo'

namespace :test do
  desc 'unit tests'
  Rake::TestTask.new :units do |t|
    t.libs << '.'
    t.libs << 'test'
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = false
  end
end

task :test => [ 'test:units' ]

task :default => :test
