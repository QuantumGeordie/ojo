require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

ENV['RAILS_ENV'] = 'test'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '.'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'awesome_print'

require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'open4'

require File.expand_path('../../lib/ojo', __FILE__)

Ojo.configure

module Ojo
  class OjoTestCase < Minitest::Test

    private

    def generate_image_with_shapes(image_destination, size_of_image, shapes = [])
      shapes_string = ''
      shapes.each do |shape|
        if shape.include? 'fill'
          shapes_string += " #{shape}"
        else
          shapes_string += " -draw '#{shape}'"
        end
      end

      im = "convert -size #{size_of_image} xc:white -fill white -stroke red #{shapes_string} #{image_destination}"

      #puts "\nim: #{im}"

      err = nil
      status = Open4::popen4(im) do |pid, stdin, stdout, stderr|
        err = stderr.read
      end

      raise "generate image: #{err}" unless status.success?
    end

    def create_location_directories
      @location = File.absolute_path('../../tmp', __FILE__)
      @branch_1 = File.join(@location, 'branch_1')
      @branch_2 = File.join(@location, 'branch_2')

      FileUtils.mkdir_p(@branch_1)
      FileUtils.mkdir_p(@branch_2)

      ::Ojo.configuration.location = @location
    end

    def remove_location_directories
      FileUtils.rm_rf Dir[File.join(@location, '*')]
    end
  end
end
