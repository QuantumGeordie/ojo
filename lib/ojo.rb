require 'collimator'

require 'ojo/rails/engine' if defined?(Rails)
require 'ojo/version'
require 'ojo/comparison'
require 'ojo/locations'
require 'ojo/output'
require 'ojo/screenshot'
require 'ojo/configuration'
require 'ojo/file_sizer'
require 'ojo/image_magician'

module Ojo
  include Collimator
end
