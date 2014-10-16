require_relative '../test_helper'

class FilesTest < Ojo::OjoTestCase
  def test_files__all_same
    files_src_1 = %w(one two three four five)
    files_src_2 = files_src_1.dup

    all_files = Ojo.send(:compile_file_lists, files_src_1, files_src_2)

    assert_equal files_src_1, all_files
    assert_equal files_src_2, all_files
  end

  def test_files__totally_different
    files_src_1 = %w(one two three four five)
    files_src_2 = %w(six seven eight)

    all_files = Ojo.send(:compile_file_lists, files_src_1, files_src_2)

    assert_equal %w(one two three four five six seven eight), all_files
  end

  def test_files__slightly_different
    files_src_1 = %w(one two three four five)
    files_src_2 = %w(four five six seven)

    all_files = Ojo.send(:compile_file_lists, files_src_1, files_src_2)

    assert_equal %w(one two three four five six seven), all_files
  end
end
