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
        puts "Screenshot taken and saved to #{filename}"
      end
      Capybara.reset!
    end

    def teardown
      Capybara.reset!
    end

    private

    def screenshot_path
      File.join(Rails.root, 'tmp', 'screenshots')
    end

    def screenshot_file(name)
      File.join(screenshot_path, branch_name, "#{name}.png")
    end

    def branch_name
      `git rev-parse --abbrev-ref HEAD`.chomp
    end

  end
end
