require_relative '../test_helper'

class DataSetsTest < Ojo::OjoTestCase
  def setup
    create_location_directories
    @data_sets = ::Ojo::DataSets.new
  end

  def teardown
    remove_location_directories
  end

  def test_data_sets
    sets_available = @data_sets.sets_available

    assert_equal 2, sets_available.length
    assert_includes sets_available, 'branch_1'
    assert_includes sets_available, 'branch_2'
  end

  def test_data_sets__lots
    branch_3 = File.join(@location, 'branch_3')
    branch_4 = File.join(@location, 'branch_4')
    diff = File.join(@location, 'diff')

    FileUtils.mkdir_p(branch_3)
    FileUtils.mkdir_p(branch_4)
    FileUtils.mkdir_p(diff)

    sets_available = @data_sets.sets_available
    assert_equal 4, sets_available.length
    assert_includes sets_available, 'branch_1'
    assert_includes sets_available, 'branch_2'
    assert_includes sets_available, 'branch_3'
    assert_includes sets_available, 'branch_4'
    refute_includes sets_available, 'diff'
  end
end
