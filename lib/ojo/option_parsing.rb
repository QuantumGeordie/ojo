module Ojo
  require 'optparse'

  def self.parse_it_baby
    options = {}
    OptionParser.new do |opts|
      opts.banner = make_the_banner

      opts.on('-i', '--initialize', 'Initialize current directory for future comparisons.') do |i|
        options[:initialize] = i
      end

      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
      end

      opts.on('-b', '--branches', 'list branches to compare') do |branches|
        options[:branches] = branches
      end

      opts.on('-p', '--path PATH', 'where are the branch files located?') do |path|
        options[:path] = path
      end

      opts.on('-o', '--open', 'open the folder containing the branch and diff data.') do |o|
        options[:open] = o
      end

    end.parse!

    if options[:branches]
      options[:branch_1] = ARGV[0]
      options[:branch_2] = ARGV[1]
    end

    options
  end


  def self.make_the_banner
    <<-EOS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Ojo sees everything.

  run after the branch compilation routines
  have been run and see if everything is the same.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    EOS
  end


end
