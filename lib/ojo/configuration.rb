module Ojo
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :fuzz
    attr_accessor :location
    attr_accessor :metric

    def initialize
      @location  = nil
      @fuzz      = '2%'
      @metric    = 'ae'
    end
  end
end
