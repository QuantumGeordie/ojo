module Ojo
  class Ojo
    def compare(branch_1, branch_2)
      all_files = compile_file_lists(get_branch_files(branch_1), get_branch_files(branch_2))

      FileUtils.mkdir_p(File.join(::Ojo.configuration.location, 'diff'))

      all_same = true
      results = { :location => ::Ojo.configuration.location, :branch_1 => branch_1, :branch_2 => branch_2, :results => {} }

      ::Ojo::ProgressBar.start({:min => 0, :max => all_files.count, :method => :percent, :step_size => 1})

      all_files.each do |file|
        diff_file = File.join(::Ojo.configuration.location, 'diff', File.basename(file))

        file_1 = File.join(::Ojo.configuration.location, branch_1, file)
        file_2 = File.join(::Ojo.configuration.location, branch_2, file)

        file_1 = nil unless File.exist?(file_1)
        file_2 = nil unless File.exist?(file_2)

        this_same = compare_one_set(file_1, file_2, diff_file)
        results[:results][file] = { :same => this_same, :file_1 => file_1, :file_2 => file_2 }
        all_same = all_same && (this_same != false)

        File.delete(diff_file) if this_same

        ::Ojo::ProgressBar.increment
      end

      ::Ojo::ProgressBar.complete
      [all_same, results]
    end

    private

    def compare_one_set(file_1, file_2, diff_file)
      same = nil
      if file_1 && file_2
        ::Ojo::FileSizer.new.make_files_same_size(file_1, file_2)

        comparison_results = compare_files(file_1, file_2, ::Ojo.configuration.metric, ::Ojo.configuration.fuzz, diff_file)
        same = unpack_comparison_results(comparison_results)
      end
      same
    end

    def get_branch_files(branch_name)
      Dir[File.join(::Ojo.configuration.location, branch_name, '*.png')].map{ |f| File.basename(f) }
    end

    def compile_file_lists(files_1, files_2)
      all_files = files_1.dup
      all_files + files_2.select{ |f2| !files_1.include?(f2) }
    end

    def unpack_comparison_results(packed)
      return false if packed.include?('image widths or heights differ')

      outputs = packed.split(/\n/)

      outputs.map! do |o|
        o.strip if o.strip.start_with?('red', 'green', 'blue', 'alpha', 'all')
      end
      outputs.compact!

      same = true

      outputs.each do |o|
        parts = o.split(' ')
        same = same && parts[1].to_f == 0
      end

      return same
    end

    def compare_files(file_1, file_2, metric, fuzz_factor, resulting_file)
      im = "compare -verbose -metric #{metric} -fuzz #{fuzz_factor} #{file_1} #{file_2} #{resulting_file}"
      ::Ojo::ImageMagician.new.make_magic(im)
    end
  end
end
