require_relative '../test_helper'

class SorterTest < Ojo::OjoTestCase

  def test_sort_results
    results = {:results => [
        { :same => true,  :file_1 => 'full_1/file_1', :file_2 => 'full_1/file_2', :not_same_pixel_count => 0   },
        { :same => false, :file_1 => 'full_2/file_1', :file_2 => 'full_2/file_2', :not_same_pixel_count => 31  },
        { :same => false, :file_1 => 'full_3/file_1', :file_2 => 'full_3/file_2', :not_same_pixel_count => 12  },
        { :same => false, :file_1 => 'full_4/file_1', :file_2 => 'full_4/file_2', :not_same_pixel_count => 55  },
        { :same => true,  :file_1 => 'full_5/file_1', :file_2 => 'full_5/file_2', :not_same_pixel_count => 0   },
        { :same => false, :file_1 => 'full_6/file_1', :file_2 => 'full_6/file_2', :not_same_pixel_count => 33  },
        { :same => false, :file_1 => 'full_7/file_1', :file_2 => 'full_7/file_2', :not_same_pixel_count => 100 },
        { :same => true,  :file_1 => 'full_8/file_1', :file_2 => 'full_8/file_2', :not_same_pixel_count => 0   },
        { :same => false, :file_1 => 'full_9/file_1', :file_2 => 'full_9/file_2', :not_same_pixel_count => 63  }
      ]
    }

    expected_sorted_order = %w(full_7 full_9 full_4 full_6 full_2 full_3)

    sorter = ::Ojo::Sorter.new(results, 24)
    sorted_results = sorter.sort

    assert_equal results[:results].count, sorted_results.count

    expected_sorted_order.each_with_index do |file, i|
      assert_match file, sorted_results[i][:file_1]
    end
  end
end
