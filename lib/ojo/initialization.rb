module Ojo
  require 'yaml'

  def self.initialize_current_directory(options = {})
    options.delete(:initialize)
    ojorc = init_file

    config_data = {}
    config_data = YAML::load_file(ojorc) if File.exist?(ojorc)
    config_data.merge!(options)

    File.open(ojorc, 'w') {|f| f.write config_data.to_yaml }
  end

  def self.read_config_file
    raise 'No initialization has been run. use --initilize and --path to get started' unless File.exist?(init_file)
    YAML::load_file(init_file)
  end

  def self.init_file
    right_here = Dir.pwd
    File.join(right_here, '.ojorc')
  end
end
