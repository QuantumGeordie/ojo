require 'ojo/rails/engine' if defined?(Rails)
require 'ojo/version'
require 'ojo/comparison'
require 'ojo/locations'
require 'ojo/output'
require 'ojo/screenshot'

require 'collimator'

module Ojo
  include Collimator

end
