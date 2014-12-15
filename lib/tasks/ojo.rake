require 'fileutils'

namespace :ojo do
  desc 'use ojo to compare two branches'
  task :compare, [:branch_1, :branch_2] => :environment do |t, args|
    branch_1 = args.fetch(:branch_1, nil)
    branch_2 = args.fetch(:branch_2, nil)

    Ojo::Manager.new.compare(branch_1, branch_2)
  end

  desc 'show ojo location setting'
  task :location => :environment do |t|
    Ojo::Manager.new.location
  end

  desc 'list ojo data sets'
  task :list => :environment do |t|
    Ojo::Manager.new.data_sets
  end

  namespace :clear do
    desc 'clear ojo results only'
    task :diff => :environment do |t|
      Ojo::Manager.new.clear_diff
    end

    desc 'clear all ojo files INCLUDING all data sets'
    task :all => :environment do |t|
      Ojo::Manager.new.clear_all
    end

  end
end
