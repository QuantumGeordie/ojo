require_relative '../test_helper'

class OutputTest < Ojo::OjoTestCase

  def test_not_too_long
    s = ::Ojo::Output.new(24).send(:make_printable_name, 'Geordie', 10)
    assert_equal 7, s.length
    assert_equal 'Geordie', s
  end

  def test_too_long_filename__even_max_odd_string
    max_length = 10
    starting_string = 'SomeOddNumberOfCharactersInThisString'
    s = ::Ojo::Output.new(24).send(:make_printable_name, starting_string, max_length)
    assert_equal 'Som....ing', s
  end

  def test_too_long_filename__even_max_even_string
    max_length = 10
    starting_string = 'SomeEvenNumberOfCharactersInThisString'
    s = ::Ojo::Output.new(24).send(:make_printable_name, starting_string, max_length)
    assert_equal 'Som....ng', s
  end

  def test_too_long_filename__odd_max_odd_string
    max_length = 11
    starting_string = 'SomeOddNumberOfCharactersInThisString'
    s = ::Ojo::Output.new(24).send(:make_printable_name, starting_string, max_length)
    assert_equal 'Som....ing', s
  end

  def test_too_long_filename__odd_max_even_string
    max_length = 11
    starting_string = 'SomeEvenNumberOfCharactersInThisString'
    s = ::Ojo::Output.new(24).send(:make_printable_name, starting_string, max_length)
    assert_equal 'Some....ing', s
  end
end
