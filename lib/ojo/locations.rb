module Ojo
  def self.location=(location)
    ::Ojo.configure unless ::Ojo.configuration
    ::Ojo.configuration.location = location
  end

  def self.location
    ::Ojo.configuration.location
  end

  def self.display_data_sets(data_sets)
    puts '~'*20 + ' Ojo ' + '~'*20
    puts 'Data sets that can be compared:'
    data_sets.each{ |d| puts "  #{d}"}
    puts '~'*45
  end
end
