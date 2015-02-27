require 'phantom_test_helper'

class TestAppTest < OjoApp::PhantomTestCase
  def test_index_page
    PageObjects::TestApp::IndexPage.visit
    Ojo.screenshot(branch_name, __method__)

    expected_screenshot_file = File.join(Ojo.configuration.location, branch_name, "#{__method__}.png")
    assert File.exist?(expected_screenshot_file), "the ojo screen shot file #{expected_screenshot_file} exists"
  end
end
