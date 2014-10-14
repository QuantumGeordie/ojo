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

require 'capybara'
require 'capybara/dsl'
require 'capybara/rails'
require 'selenium-webdriver'

require 'page_objects'

Capybara.default_driver = :selenium

module Ojo
  class SeleniumTestCase < Minitest::Test
    include Capybara::DSL

    # def initialize_browser_size_for_test
    #   @browser_dimensions = ENV['BROWSER_SIZE'] || '960x1000'
    #   if @browser_dimensions
    #     @starting_dimensions = get_current_browser_dimensions
    #     w = @browser_dimensions.split('x')[0]
    #     h = @browser_dimensions.split('x')[1]
    #     resize_browser(w, h)
    #   end
    # end
    #
    # def resize_browser(width, height)
    #   page.driver.browser.manage.window.resize_to(width.to_i, height.to_i)
    # end
    #
    # def get_current_browser_dimensions
    #   page.driver.browser.manage.window.size
    # end

  end
end
