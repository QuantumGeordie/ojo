require_relative '../test_helper'

class ComparisonTest < Ojo::OjoTestCase
  require 'fileutils'

  def setup
    create_location_directories
  end

  def teardown
    remove_location_directories
  end

  def test_comparison__same
    # for reference, draw parameters look like this for rectangle
    # rectangle x0,y0 x1,y1

    shapes = []
    shapes << "rectangle 20,0 190,190"
    shapes << "rectangle 30,10 100,60"

    file_1 = File.join(@branch_1, 'test_one.png')
    generate_image_with_shapes(file_1, '200x200', shapes)
    assert File.exist?(file_1)

    file_2 = File.join(@branch_2, 'test_one.png')
    generate_image_with_shapes(file_2, '200x200', shapes)
    assert File.exist?(file_2)

    r = Ojo.compare('branch_1', 'branch_2')

    assert r[0], 'the all_pass status'
    assert_equal @location, r[1][:location]
    assert_equal 'branch_1', r[1][:branch_1]
    assert_equal 'branch_2', r[1][:branch_2]
    assert_equal 1, r[1][:results].keys.count
    assert_equal File.basename(file_1), r[1][:results].keys.first
    assert_equal true, r[1][:results]['test_one.png'][:same]
    assert_equal file_1, r[1][:results]['test_one.png'][:file_1]
    assert_equal file_2, r[1][:results]['test_one.png'][:file_2]

  end

  def test_comparison__different
    # for reference, draw parameters look like this for rectangle
    # rectangle x0,y0 x1,y1

    shapes = []
    shapes << "rectangle 20,0 190,190"
    shapes << "rectangle 30,10 100,60"

    file_1 = File.join(@branch_1, 'test_one.png')
    generate_image_with_shapes(file_1, '200x200', shapes)
    assert File.exist?(file_1)

    shapes.pop
    shapes << "rectangle 120,100 150,160"

    file_2 = File.join(@branch_2, 'test_one.png')
    generate_image_with_shapes(file_2, '200x200', shapes)
    assert File.exist?(file_2)

    r = Ojo.compare('branch_1', 'branch_2')

    refute r[0], 'the all_pass status'
    assert_equal @location, r[1][:location]
    assert_equal 'branch_1', r[1][:branch_1]
    assert_equal 'branch_2', r[1][:branch_2]
    assert_equal 1, r[1][:results].keys.count
    assert_equal File.basename(file_1), r[1][:results].keys.first
    assert_equal false, r[1][:results]['test_one.png'][:same]
    assert_equal file_1, r[1][:results]['test_one.png'][:file_1]
    assert_equal file_2, r[1][:results]['test_one.png'][:file_2]
  end

  private

  def create_location_directories
    @location = File.expand_path('../../tmp')
    @branch_1 = File.join(@location, 'branch_1')
    @branch_2 = File.join(@location, 'branch_2')

    FileUtils.mkdir_p(@branch_1)
    FileUtils.mkdir_p(@branch_2)

    Ojo.location = @location
  end

  def remove_location_directories
    FileUtils.rm_rf(@branch_1)
    FileUtils.rm_rf(@branch_2)
    FileUtils.rm_rf(File.join(@location, 'diff'))
  end
end
