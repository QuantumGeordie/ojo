require 'selenium_test_helper'

class OjoTest < Ojo::SeleniumTestCase
  require 'fileutils'

  def test_index_page
    FileUtils.mkdir_p(File.join(Ojo.location, 'branch_1'))
    FileUtils.mkdir_p(File.join(Ojo.location, 'branch_2'))
    FileUtils.mkdir_p(File.join(Ojo.location, 'branch_3'))

    index_page = PageObjects::Ojo::IndexPage.visit

    assert_equal 'OjoApp',                             index_page.parent_app.text
    assert_equal Gem.loaded_specs['ojo'].version.to_s, index_page.ojo_version.text
    assert_equal Ojo.location,                         index_page.data_location.text

    assert_equal 3, index_page.data_sets.count

    FileUtils.rm_rf(File.join(Ojo.location, 'branch_1'))
    FileUtils.rm_rf(File.join(Ojo.location, 'branch_2'))
    FileUtils.rm_rf(File.join(Ojo.location, 'branch_3'))
  end

  def test_local_index_page
    index_page = PageObjects::Ojo::LocalIndexPage.visit
  end
end
