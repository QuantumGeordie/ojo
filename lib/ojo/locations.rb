module Ojo
  @location = nil

  def self.location=(location)
    @location = location
  end

  def self.location
    @location
  end

  def self.get_data_sets_available
    data_sets = []
    if @location
      data_sets = Dir[File.join(location, '*')].select{ |d| File.directory?(d) && File.basename(d) != 'diff' }.map{ |d| File.basename(d) }
    end
    data_sets
  end

  def self.display_data_sets(data_sets)
    puts '~'*20 + ' Ojo ' + '~'*20
    puts 'Data sets that can be compared:'
    data_sets.each{ |d| puts "  #{d}"}
    puts '~'*45
  end
end
