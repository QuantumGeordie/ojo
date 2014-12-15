module Ojo
  class DataSets
    def sets_available
      data_sets = []
      if ::Ojo.configuration.location
        data_sets = Dir[File.join(::Ojo.configuration.location, '*')].select{ |d| File.directory?(d) && File.basename(d) != 'diff' }.map{ |d| File.basename(d) }.sort
      end
      data_sets
    end
  end
end
