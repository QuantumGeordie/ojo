require 'ae_page_objects'

ActiveSupport::Dependencies.autoload_paths << 'test'

module PageObjects
  module TestApp
    class Site < ::AePageObjects::Site

    end
  end
end

PageObjects::TestApp::Site.initialize!
