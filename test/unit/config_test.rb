require_relative '../test_helper'

class ConfigTest < Ojo::OjoTestCase

  def test_locations
    Ojo.location = File.expand_path('../../tmp')
    assert_equal File.expand_path('../../tmp'), Ojo.location
  end
end
