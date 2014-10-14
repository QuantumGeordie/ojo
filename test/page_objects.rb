require 'ae_page_objects'

ActiveSupport::Dependencies.autoload_paths << 'test'

module PageObjects
  module Ojo
    class Site < ::AePageObjects::Site

    end
  end
end

PageObjects::Ojo::Site.initialize!

