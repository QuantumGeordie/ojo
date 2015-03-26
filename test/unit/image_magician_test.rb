require_relative '../test_helper'

class ImageMagicianTest < Ojo::OjoTestCase

  def setup
    @image_magician = ::Ojo::ImageMagician.new
  end

  def test_get_color_values
    raw = raw_string('1', '22', '303', '4044')
    color_values = @image_magician.send(:get_color_values, raw)

    assert_equal '1',    color_values[:red]
    assert_equal '22',   color_values[:green]
    assert_equal '303',  color_values[:blue]
    assert_equal '4044', color_values[:all]
  end

  def test_unpack_comparison_result
    assert @image_magician.unpack_comparison_result(raw_string('0', '0', '0', '0')),         'all colors equal 0'

    packed = raw_string('123', '234', '345', '456')
    unpacked = @image_magician.unpack_comparison_result(packed)
    refute unpacked[0], 'all colors greater than 0'
    assert_equal 456, unpacked[1]

    packed = raw_string('123', '0', '0', '0')
    unpacked = @image_magician.unpack_comparison_result(packed)
    refute unpacked[0], 'red greater than 0'
    assert_equal 0, unpacked[1]

    packed = raw_string('0', '234', '0', '0')
    unpacked = @image_magician.unpack_comparison_result(packed)
    refute unpacked[0], 'green greater than 0'
    assert_equal 0, unpacked[1]

    packed = raw_string('0', '0', '345', '0')
    unpacked = @image_magician.unpack_comparison_result(packed)
    refute unpacked[0], 'blue greater than 0'
    assert_equal 0, unpacked[1]

    packed = raw_string('0', '0', '0', '456')
    unpacked = @image_magician.unpack_comparison_result(packed)
    refute unpacked[0], "'all' greater than 0"
    assert_equal 456, unpacked[1]
  end

  private

  def raw_string(red, green, blue, all)
    "/Users/someone/branch_1/test_one.png PNG 200x200 200x200+0+0 16-bit sRGB 1.04KB 0.000u 0:00.000\n/Users/someone/branch_2/test_one.png PNG 200x200 200x200+0+0 16-bit sRGB 1.05KB 0.000u 0:00.000\nImage: /Users/someone/branch_1/test_one.png\n  Channel distortion: AE\n    red: #{red}\n    green: #{green}\n    blue: #{blue}\n    all: #{all}\n/Users/someone/branch_1/test_one.png=>/Users/someone/diff/test_one.png PNG 200x200 200x200+0+0 16-bit sRGB 6c 1.18KB 0.010u 0:00.000\n"
  end
end
