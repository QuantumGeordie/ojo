module Ojo
  require 'open4'
  require 'fileutils'

  def self.compare(branch_1, branch_2)
    all_files = compile_file_lists(get_branch_files(branch_1), get_branch_files(branch_2))

    FileUtils.mkdir_p(File.join(Ojo.configuration.location, 'diff'))

    all_same = true
    results = { :location => Ojo.configuration.location, :branch_1 => branch_1, :branch_2 => branch_2, :results => {} }

    ProgressBar.start({:min => 0, :max => all_files.count, :method => :percent, :step_size => 1})

    all_files.each do |file|
      diff_file = File.join(Ojo.configuration.location, 'diff', File.basename(file))

      file_1 = File.join(Ojo.configuration.location, branch_1, file)
      file_2 = File.join(Ojo.configuration.location, branch_2, file)

      file_1 = nil unless File.exist?(file_1)
      file_2 = nil unless File.exist?(file_2)

      this_same = compare_one_set(file_1, file_2, diff_file)
      results[:results][file] = { :same => this_same, :file_1 => file_1, :file_2 => file_2 }
      all_same = all_same && (this_same != false)

      File.delete(diff_file) if this_same

      ProgressBar.increment
    end

    ProgressBar.complete
    [all_same, results]
  end

  private

  def self.compare_one_set(file_1, file_2, diff_file)
    same = nil
    if file_1 && file_2
      do_some_file_size_stuff file_1, file_2

      comparison_results = compare_files(file_1, file_2, Ojo.configuration.metric, Ojo.configuration.fuzz, diff_file)
      same = unpack_comparison_results(comparison_results)
    end
    same
  end

  def self.get_file_dimensions(file)
    im = "identify -format '%[fx:w]x%[fx:h]' #{file}"

    output = nil
    status = Open4::popen4(im) do |pid, stdin, stdout, stderr|
      output = stdout.read
    end
    raise "problem getting dimensions of #{file}" unless status.success?
    output.chomp
  end


  def self.get_branch_files(branch_name)
    Dir[File.join(Ojo.configuration.location, branch_name, '*.png')].map{ |f| File.basename(f) }
  end

  def self.compile_file_lists(files_1, files_2)
    all_files = files_1.dup
    all_files + files_2.select{ |f2| !files_1.include?(f2) }
  end

  def self.unpack_comparison_results(packed)
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

  def self.compare_files(file_1, file_2, metric, fuzz_factor, resulting_file)
    command = "compare -verbose -metric #{metric} -fuzz #{fuzz_factor} #{file_1} #{file_2} #{resulting_file}"
    do_imagemagick(command)
  end

  # def self.compare(file_1, file_2, metric, fuzz_factor, resulting_file)

  def self.do_imagemagick(command_string)
    output = nil
    status = Open4::popen4(command_string) do |pid, stdin, stdout, stderr|
      output = stderr.read
    end

    output
  end

end
