require 'phantom_test_helper'

class TestAppTest < OjoApp::PhantomTestCase
  def test_index_page
    PageObjects::TestApp::IndexPage.visit
    Ojo.screenshot(branch_name, __method__)
  end
end
