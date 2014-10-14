namespace :ojo do
  desc 'use ojo to compare two branches'
  task :compare, [:branch_1, :branch_2] => :environment do |t, args|
    results = Ojo.compare(args[:branch_1], args[:branch_2])
    Ojo.display_to_console results[1]
  end

  desc 'show ojo location setting'
  task :location => :environment do |t|
    puts Ojo.location
  end
end
