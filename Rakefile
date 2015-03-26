require 'rake'
require 'rake/testtask'
require 'bundler/gem_tasks'

require 'ojo'

namespace :test do
  desc 'unit tests'
  Rake::TestTask.new :units do |t|
    t.libs << '.'
    t.libs << 'test'
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = false
  end

  desc 'phantom js'
  Rake::TestTask.new :phantom do |t|
    t.libs << '.'
    t.libs << 'test'
    t.pattern = 'test/phantom/**/*_test.rb'
    t.verbose = false
  end
end

desc 'demo'
Rake::TestTask.new :demo do |t|
  t.libs << '.'
  t.libs << 'test'
  t.pattern = 'test/demo/**/*_test.rb'
  t.verbose = false
end

task :test => %w(test:units test:phantom)

task :default => :test
