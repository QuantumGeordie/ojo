require_relative '../test_helper'

class DemoTest < Ojo::OjoTestCase

  def setup
    create_location_directories
    @manager = ::Ojo::Manager.new
    Collimator::ProgressBar.stubs(:put_current_progress)
    Collimator::ProgressBar.stubs(:complete)
  end

  def teardown
    remove_location_directories
  end

  def test_locations
    @manager.location
  end

  def test_data_sets
    @manager.data_sets
  end

  def test_compare
    make_some_real_files

    branch_1_name = @branch_1.split('/').last
    branch_2_name = @branch_2.split('/').last

    @manager.compare branch_1_name, branch_2_name
  end

  def test_compare__missing_branch_names
    make_some_real_files

    branch_1_name = @branch_1.split('/').last
    branch_2_name = @branch_2.split('/').last

    @manager.compare nil, branch_2_name
    puts ''
    puts ''

    @manager.compare branch_1_name, nil
    puts ''
    puts ''

    branch_1a = File.join(@location, 'branch_1a')
    FileUtils.mkdir_p(branch_1a)
    file_1a = File.join(branch_1a, 'test_one.png')
    generate_one_real_file file_1a

    @manager.compare nil, nil
    puts ''
    puts ''

    @manager.compare branch_1_name, branch_2_name
  end

  def test_compare__missing_files
    make_some_real_files

    filename = File.join(@branch_1, 'test_two.png')
    generate_one_real_file filename
    filename = File.join(@branch_2, 'test_three.png')
    generate_one_real_file filename

    Collimator::ProgressBar.stubs(:put_current_progress)
    Collimator::ProgressBar.stubs(:complete)

    branch_1_name = @branch_1.split('/').last
    branch_2_name = @branch_2.split('/').last

    @manager.compare branch_1_name, branch_2_name

  end
end
