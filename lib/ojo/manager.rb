module Ojo
  class Manager
    def location
      puts "Ojo file location: #{::Ojo.configuration.location}"
    end

    def data_sets
      data_sets = ::Ojo::DataSets.new.sets_available
      ::Ojo.display_data_sets(data_sets)
    end

    def clear_diff
      FileUtils.rm_rf File.join(::Ojo.configuration.location, 'diff')
    end

    def clear_all
      data_sets = ::Ojo::DataSets.new.sets_available
      FileUtils.rm_rf File.join(::Ojo.configuration.location, 'diff')
      data_sets.each { |d| FileUtils.rm_rf(File.join(::Ojo.configuration.location, d)) }
    end

    def compare(branch_1, branch_2)
      unless branch_1 && branch_2
        branches = ::Ojo::DataSets.new.sets_available
        unless branch_1
          branches.each do |branch|
            if branch != branch_2
              branch_1 = branch
              break
            end
          end
        end

        unless branch_2
          branches.each do |branch|
            if branch != branch_1
              branch_2 = branch
              break
            end
          end
        end
      end

      results = ::Ojo::Ojo.new.compare(branch_1, branch_2)
      ::Ojo::Output.new.display_to_console results[1]
    end

  end
end
