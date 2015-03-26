if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

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

      err = nil
      status = Open4::popen4(im) do |pid, stdin, stdout, stderr|
        err = stderr.read
      end

      raise "generate image: #{err}" unless status.success?
    end

    def make_some_real_files
      file_1 = File.join(@branch_1, 'test_one.png')
      file_2 = File.join(@branch_2, 'test_one.png')
      generate_one_real_file file_1
      generate_one_real_file file_2
    end

    def make_some_temp_files
      @temp_diff_location = File.join(::Ojo.configuration.location, 'diff')
      @temp_diff_filename = File.join(@temp_diff_location, 'some_test_diff.txt')
      FileUtils.mkdir_p @temp_diff_location
      File.open(@temp_diff_filename, 'w') { |f| f.write '' }

      @filename_1 = File.join(@branch_1, 'some_test.txt')
      @filename_2 = File.join(@branch_2, 'some_test.txt')
      File.open(@filename_1, 'w') { |f| f.write '' }
      File.open(@filename_2, 'w') { |f| f.write '' }
    end

    def generate_one_real_file(name)
      shapes = []
      shapes << "rectangle 20,0 190,190"
      shapes << "rectangle 30,10 100,60"

      generate_image_with_shapes(name, '200x200', shapes)
    end

    def create_location_directories
      @location = File.absolute_path('../../tmp', __FILE__)
      @branch_1 = File.join(@location, 'branch_1')
      @branch_2 = File.join(@location, 'branch_2')

      FileUtils.mkdir_p(@branch_1)
      FileUtils.mkdir_p(@branch_2)

      ::Ojo.configuration.location = @location
    end

    def assert_compare_output(output_string, branch_names)
      sa = output_string.split("\n")

      assert_match 'Ojo v.',                     sa[1]
      assert_match 'file location:',             sa[2]
      assert_match 'data sets compared:',        sa[4]
      assert_match 'File',                       sa[6]
      assert_match 'Magnitude',                  sa[6]
      assert_match "\e[1;32mtest_one.png\e[0m",  sa[8]
      assert_match "\e[1;32mP\e[0m",             sa[8]
      assert_match 'Results: All Same',          sa[10]
      assert_match 'Difference Files at',        sa[11]
    end

    def assert_compare_output__missing_files(output_string, branch_names)
      sa = output_string.split("\n")

      assert_match 'Ojo v.',                    sa[1]
      assert_match 'file location:',            sa[2]
      assert_match 'data sets compared:',       sa[4]
      assert_match 'File',                      sa[6]
      assert_match 'Magnitude',                 sa[6]
      # assert_match "\e[1;32mtest_one.png\e[0m", sa[8]
      # assert_match "\e[1;32mP\e[0m",            sa[8]
      # assert_match "\e[1;34mtest_",             sa[9]
      # assert_match "\e[1;34m-\e[0m",            sa[9]
      # assert_match "\e[1;34mtest_",             sa[10]
      # assert_match "\e[1;34m-\e[0m",            sa[10]
      assert_match 'Results: All Same',         sa[12]
      assert_match 'Difference Files at',       sa[13]
    end

    def remove_location_directories
      FileUtils.rm_rf Dir[File.join(@location, '*')]
    end

    def capture_output
      out = StringIO.new
      $stdout = out
      yield
      return out
    ensure
      $stdout = STDOUT
    end
  end
end
