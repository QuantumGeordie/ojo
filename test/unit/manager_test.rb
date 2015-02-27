require_relative '../test_helper'

class ManagerTest < Ojo::OjoTestCase

  def setup
    create_location_directories
    @manager = ::Ojo::Manager.new
  end

  def teardown
    remove_location_directories
    $stdout = STDOUT
  end

  def test_locations
    out = capture_output do
      @manager.location
    end

    assert_match Ojo.configuration.location, out.string.strip
  end

  def test_data_sets
    out = capture_output do
      @manager.data_sets
    end

    sa = out.string.split("\n")

    assert_equal '~~~~~~~~~~~~~~~~~~~~ Ojo ~~~~~~~~~~~~~~~~~~~~', sa[0]
    assert_equal 'Data sets that can be compared:',               sa[1]
    assert_equal '  branch_1',                                    sa[2]
    assert_equal '  branch_2',                                    sa[3]
    assert_equal '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~', sa[4]
  end

  def test_clear__diff
    make_some_temp_files

    assert File.exist?(@temp_diff_filename)
    assert File.exist?(@filename_1)
    assert File.exist?(@filename_2)

    @manager.clear_diff

    refute File.exist?(@temp_diff_filename)
    assert File.exist?(@filename_1)
    assert File.exist?(@filename_2)
  end

  def test_clear__all
    make_some_temp_files

    assert File.exist?(@temp_diff_filename)
    assert File.exist?(@filename_1)
    assert File.exist?(@filename_2)

    @manager.clear_all

    refute File.exist?(@temp_diff_filename)
    refute File.exist?(@filename_1)
    refute File.exist?(@filename_2)
  end

  def test_compare
    make_some_real_files
    Collimator::ProgressBar.stubs(:put_current_progress)
    Collimator::ProgressBar.stubs(:complete)

    branch_1_name = @branch_1.split('/').last
    branch_2_name = @branch_2.split('/').last

    out = capture_output do
      Date.stub :today, Date.parse('1/10/2014') do
        @manager.compare branch_1_name, branch_2_name
      end
    end

    assert_compare_output out.string, %w(branch_1 branch_2)
  end

  def test_compare__missing_branch_names
    make_some_real_files
    Collimator::ProgressBar.stubs(:put_current_progress)
    Collimator::ProgressBar.stubs(:complete)

    branch_1_name = @branch_1.split('/').last
    branch_2_name = @branch_2.split('/').last

    out = capture_output do
      Date.stub :today, Date.parse('1/10/2014') do
        @manager.compare nil, branch_2_name
      end
    end
    assert_compare_output out.string, %w(branch_1 branch_2)

    out = capture_output do
      Date.stub :today, Date.parse('1/10/2014') do
        @manager.compare branch_1_name, nil
      end
    end
    assert_compare_output out.string, %w(branch_1 branch_2)

    branch_1a = File.join(@location, 'branch_1a')
    FileUtils.mkdir_p(branch_1a)
    file_1a = File.join(branch_1a, 'test_one.png')
    generate_one_real_file file_1a

    out = capture_output do
      Date.stub :today, Date.parse('1/10/2014') do
        @manager.compare nil, nil
      end
    end
    assert_compare_output out.string, %w(branch_1 branch_1a)

    out = capture_output do
      Date.stub :today, Date.parse('1/10/2014') do
        @manager.compare branch_1_name, branch_2_name
      end
    end
    assert_compare_output out.string, %w(branch_1 branch_2)
  end

  private

  def assert_compare_output(output_string, branch_names)
    sa = output_string.split("\n")

    assert_equal '+-----------------------------------------------------------------------------------------------------------------------------------------+', sa[0]
    assert_match 'Ojo v.',                                                                                                                                      sa[1]
    assert_match 'file location:',                                                                                                                              sa[2]
    assert_equal '|                                                               10/01/2014                                                                |', sa[3]
    assert_equal '+-----------------------------------------------------------------------------------------------------------------------------------------+', sa[4]
    assert_match branch_names.first,                                                                                                                            sa[5]
    assert_match branch_names.last,                                                                                                                             sa[5]
    assert_equal '|--------------------------------------------------------------+--------------------------------------------------------------+-----------|', sa[6]
    assert_equal "|  \e[1;32mtest_one.png\e[0m                                                |  \e[1;32mtest_one.png\e[0m                                                |   \e[1;32mPASS\e[0m    |", sa[7]
    assert_equal '+-----------------------------------------------------------------------------------------------------------------------------------------+', sa[8]
    assert_equal '|                                                            Results: All Same                                                            |', sa[9]
    assert_match 'Difference Files at',                                                                                                                         sa[10]
    assert_equal '+-----------------------------------------------------------------------------------------------------------------------------------------+', sa[11]
  end

  def make_some_real_files
    file_1 = File.join(@branch_1, 'test_one.png')
    file_2 = File.join(@branch_2, 'test_one.png')
    generate_one_real_file file_1
    generate_one_real_file file_2
  end

  def generate_one_real_file(name)
    shapes = []
    shapes << "rectangle 20,0 190,190"
    shapes << "rectangle 30,10 100,60"

    generate_image_with_shapes(name, '200x200', shapes)
  end

  def make_some_temp_files
    @temp_diff_location = File.join(Ojo.configuration.location, 'diff')
    @temp_diff_filename = File.join(@temp_diff_location, 'some_test_diff.txt')
    FileUtils.mkdir_p @temp_diff_location
    File.open(@temp_diff_filename, 'w') { |f| f.write '' }

    @filename_1 = File.join(@branch_1, 'some_test.txt')
    @filename_2 = File.join(@branch_2, 'some_test.txt')
    File.open(@filename_1, 'w') { |f| f.write '' }
    File.open(@filename_2, 'w') { |f| f.write '' }
  end
end
