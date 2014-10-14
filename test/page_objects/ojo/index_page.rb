module PageObjects
  module Ojo
    class IndexPage < OjoPage
      path :ojo

      collection :data_sets, :locator => 'table.branches', :item_locator => 'tr.branch'
    end
  end
end
