# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ojo/version'

Gem::Specification.new do |spec|
  spec.name          = "ojo"
  spec.version       = Ojo::VERSION
  spec.authors       = ["geordie"]
  spec.email         = ["george.speake@gmail.com"]
  spec.summary       = %q{ojo is the eyes of the appearance test}
  spec.description   = %q{ojo will compare a few sets of screen shots and report results.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["ojo"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'collimator'
  spec.add_dependency 'open4'
end

