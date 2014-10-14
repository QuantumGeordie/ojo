module PageObjects
  module Ojo
    class OjoPage < ::AePageObjects::Document
      element :ojo_version,   :locator => '#js-ojo_version'
      element :parent_app,    :locator => '#js-parent_application'
      element :data_location, :locator => '#js-ojo_data_location'
    end
  end
end
