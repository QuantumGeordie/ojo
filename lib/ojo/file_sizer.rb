module Ojo
  class FileSizer
    def make_files_same_size(file_1, file_2)
      dim_1 = get_file_dimensions(file_1)
      dim_2 = get_file_dimensions(file_2)

      unless dim_1 == dim_2
        x, y = max_dimensions(dim_1, dim_2)
        add_extra_to_file x, y, file_1
        add_extra_to_file x, y, file_2
      end
    end

    private

    def get_file_dimensions(file)
      im = "identify -format '%[fx:w]x%[fx:h]' #{file}"

      output = nil
      status = Open4::popen4(im) do |pid, stdin, stdout, stderr|
        output = stdout.read
      end
      raise "problem getting dimensions of #{file}" unless status.success?
      output.chomp
    end

    def add_extra_to_file(x, y, filename)
      basename = File.basename(filename, '.*')
      temp_filename = File.join(File.dirname(filename), "#{basename}_tmp.png")
      make_canvas x, y, temp_filename

      im = "convert #{temp_filename} #{filename} -composite #{temp_filename}"
      ::Ojo::ImageMagician.new.make_magic(im)

      FileUtils.mv(temp_filename, filename)
    end

    def max_dimensions(dim_1, dim_2)
      x1, y1 = dim_1.split('x')
      x2, y2 = dim_2.split('x')

      x = [x1, x2].max
      y = [y1, y2].max
      [x, y]
    end

    def make_canvas(x, y, filename)
      im = "convert -size #{x}x#{y} canvas:yellow #{filename}"
      ::Ojo::ImageMagician.new.make_magic(im)
    end
  end
end
