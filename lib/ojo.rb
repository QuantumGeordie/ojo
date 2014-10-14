require 'ojo/rails/engine' if defined?(Rails)
require 'ojo/version'
require 'ojo/comparison'
require 'ojo/option_parsing'
require 'ojo/initialization'
require 'ojo/output'

require 'collimator'

module Ojo
  include Collimator

end
