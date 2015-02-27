ENV['RAILS_ENV'] = 'test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '.'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rails/all'
require 'ojo'
require 'test_app/test_app'

require 'minitest/autorun'

require 'awesome_print'

require 'capybara/dsl'
require 'capybara/rails'
require 'capybara/poltergeist'

require 'page_objects'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

module OjoApp
  class PhantomTestCase < Minitest::Test
    include Capybara::DSL

    def setup
      Ojo.screenshotter = lambda do |filename|
        page.save_screenshot(filename)
      end
      Capybara.reset!
    end

    def teardown
      Capybara.reset!
      remove_test_screenshots
    end

    private

    def branch_name
      `git rev-parse --abbrev-ref HEAD`.chomp
    end

    def remove_test_screenshots
      branch_location = File.join(Ojo.configuration.location, branch_name)
      FileUtils.rm_rf branch_location
    end
  end
end
