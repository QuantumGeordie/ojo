module Ojo
  require 'open4'
  require 'fileutils'

  def self.compare(branch_1, branch_2)

    files_1 = Dir[File.join(self.location, branch_1, '*.png')].map{ |f| File.basename(f) }
    files_2 = Dir[File.join(self.location, branch_2, '*.png')].map{ |f| File.basename(f) }

    all_files = compile_file_lists(files_1, files_2)

    FileUtils.mkdir_p(File.join(self.location, 'diff'))

    all_same = true
    results = { :location => self.location, :branch_1 => branch_1, :branch_2 => branch_2, :results => {} }

    ProgressBar.start({:min => 0, :max => all_files.count, :method => :percent, :step_size => 1})

    all_files.each do |file|
      diff_file = File.join(self.location, 'diff', File.basename(file))

      file_1 = File.join(location, branch_1, file)
      file_2 = File.join(location, branch_2, file)

      file_1 = nil unless File.exist?(file_1)
      file_2 = nil unless File.exist?(file_2)

      if file_1 && file_2

        output = nil
        status = run_comparison(file_1, file_2, 'ae', '2%', diff_file) do |out|
          output = out
        end

        this_same = false
        red  = green = blue = alpha = all = '_'
        if status.success?
          this_same, red, green, blue, alpha, all = unpack_comparison_results(output)
        else
          this_same  = false
          red   = green = blue  = alpha = all   = 'XX'
          file_diff = 'none'
        end

        results[:results][file] = { :same => this_same, :file_1 => file_1, :file_2 => file_2 }
        all_same = all_same && this_same
      else
        results[:results][file] = { :same => nil, :file_1 => file_1, :file_2 => file_2 }
      end

      ProgressBar.increment
    end

    ProgressBar.complete
    [all_same, results]
  end

  private

  def self.compile_file_lists(files_1, files_2)
    all_files = files_1.dup
    all_files = all_files + files_2.select{ |f2| !files_1.include?(f2) }
  end

  def self.unpack_comparison_results(packed, &unpacked)
    outputs = packed.split(/\n/)

    outputs.map! do |o|
      o.strip if o.strip.start_with?('red', 'green', 'blue', 'alpha', 'all')
    end
    outputs.compact!

    red   = ''
    green = ''
    blue  = ''
    alpha = ''
    all   = ''

    same = true
    outputs.each do |o|
      parts = o.split(' ')
      same = same && parts[1].to_f == 0

      red   = parts[1] if parts[0].start_with?('red')
      green = parts[1] if parts[0].start_with?('green')
      blue  = parts[1] if parts[0].start_with?('blue')
      alpha = parts[1] if parts[0].start_with?('alpha')
      all   = parts[1] if parts[0].start_with?('all')
    end

    return [same, red, green, blue, alpha, all]
    #yield(same, red, green, blue, alpha, all)
  end

  def self.run_comparison(file_1, file_2, metric, fuzz_factor, resulting_file, &b)
    imagemagick_command = "compare -verbose -metric #{metric} -fuzz #{fuzz_factor} #{file_1} #{file_2} #{resulting_file}"

    output = nil
    status = Open4::popen4(imagemagick_command) do |pid, stdin, stdout, stderr|
      output = stderr.read
    end

    yield(output) if b

    status
  end

end