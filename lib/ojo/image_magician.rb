module Ojo
  class ImageMagician
    def make_magic(command_string)
      output = nil
      status = Open4::popen4(command_string) do |pid, stdin, stdout, stderr|
        output = stderr.read
      end
      output
    end

    def unpack_comparison_result(packed)
      return false if packed.include?('image widths or heights differ')

      color_values = get_color_values(packed)

      same = true
      color_values.each_pair do |color, value|
        same = same && value.to_f == 0
      end

      return same
    end

    private

    def get_color_values(raw)
      # raw looks like
      # "/Users/geordie/src/gems/ojo/tmp/branch_1/test_one.png PNG 200x200 200x200+0+0 16-bit sRGB 1.04KB 0.000u 0:00.000\n/Users/geordie/src/gems/ojo/tmp/branch_2/test_one.png PNG 200x200 200x200+0+0 16-bit sRGB 1.05KB 0.000u 0:00.000\nImage: /Users/geordie/src/gems/ojo/tmp/branch_1/test_one.png\n  Channel distortion: AE\n    red: 944\n    green: 944\n    blue: 944\n    all: 944\n/Users/geordie/src/gems/ojo/tmp/branch_1/test_one.png=>/Users/geordie/src/gems/ojo/tmp/diff/test_one.png PNG 200x200 200x200+0+0 16-bit sRGB 6c 1.18KB 0.010u 0:00.000\n"
      outputs = raw.split(/\n/).select { |o| o.strip.start_with?('red', 'green', 'blue', 'alpha', 'all') }

      out_hash = {}
      outputs.each do |line|
        k, v = line.strip.split(':')
        out_hash[k.to_sym] = v.strip
      end

      out_hash
    end
  end
end
