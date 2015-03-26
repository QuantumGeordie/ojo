module Ojo
  class Sorter
    attr_accessor :results
    attr_reader :magnitude_max

    def initialize(results, magnitude_max)
      @results = results
      @magnitude_max = magnitude_max
    end

    def sort
      sub_set = @results[:results]
      sub_set.sort! do |a, b|
        a_val = a[:not_same_pixel_count] ? a[:not_same_pixel_count] : 0
        b_val = b[:not_same_pixel_count] ? b[:not_same_pixel_count] : 0
        b_val <=> a_val
      end
      sub_set = scale_not_same_pixel_count(sub_set, magnitude_max)
    end

    private

    def scale_not_same_pixel_count(data, max)
      return data if data.first[:not_same_pixel_count] == 0

      log_scaled_data_points = data.map { |point| Math.log(point[:not_same_pixel_count].to_s.to_f) }.map{ |point| point == -1.0/0.0 ? 0 : point }
      largest_data_point = log_scaled_data_points.first
      scale_factor = 1.0 * largest_data_point / max

      new_data = []
      data.each_with_index  do |v, i|
        modified = v.clone
        modified[:not_same_pixel_count] = log_scaled_data_points[i] / scale_factor
        new_data << modified
      end
      new_data
    end
  end
end
