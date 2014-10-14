module Ojo
  require 'yaml'
  require 'fileutils'

  @location = nil

  def self.location=(location)
    @location = location
  end

  def self.location
    @location
  end

  def self.clear_results
    puts "hi, i'm going to clear the diff results from #{@location}"
    FileUtils.rm_rf(File.join(@location, 'diff')) if @location
  end

  def self.initialize_current_directory(options = {})
    options.delete(:initialize)
    ojorc = init_file

    config_data = {}
    config_data = YAML::load_file(ojorc) if File.exist?(ojorc)
    config_data.merge!(options)

    File.open(ojorc, 'w') {|f| f.write config_data.to_yaml }
  end

  def self.read_config_file
    raise 'No initialization has been run. use --initilize and --path to get started' unless init_file_exists?
    YAML::load_file(init_file)
  end

  def self.init_file_exists?
    File.exist?(init_file)
  end

  def self.init_file
    right_here = Dir.pwd
    File.join(right_here, '.ojorc')
  end
end
