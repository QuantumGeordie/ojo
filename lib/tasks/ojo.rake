require 'fileutils'

namespace :ojo do
  desc 'use ojo to compare two branches'
  task :compare, [:branch_1, :branch_2] => :environment do |t, args|
    branch_1 = args.fetch(:branch_1, nil)
    branch_2 = args.fetch(:branch_2, nil)

    unless branch_1 && branch_2
      branches = Ojo.get_data_sets_available
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

    results = Ojo.compare(branch_1, branch_2)
    Ojo.display_to_console results[1]
  end

  desc 'show ojo location setting'
  task :location => :environment do |t|
    puts Ojo.location
  end

  desc 'list ojo data sets'
  task :list => :environment do |t|
    data_sets = Ojo.get_data_sets_available
    Ojo.display_data_sets(data_sets)
  end

  namespace :clear do
    desc 'clear ojo results only'
    task :diff => :environment do |t|
      FileUtils.rm_rf File.join(Ojo.location, 'diff')
    end

    desc 'clear all ojo files INCLUDING all data sets'
    task :all => :environment do |t|
      data_sets = Ojo.get_data_sets_available
      FileUtils.rm_rf File.join(Ojo.location, 'diff')
      data_sets.each { |d| FileUtils.rm_rf(File.join(Ojo.location, d)) }
    end

  end
end
