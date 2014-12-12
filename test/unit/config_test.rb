require_relative '../test_helper'

class ConfigTest < Ojo::OjoTestCase

  def test_locations
    Ojo.configuration.location = File.expand_path('../../tmp')
    assert_equal File.expand_path('../../tmp'), Ojo.configuration.location
  end
end
