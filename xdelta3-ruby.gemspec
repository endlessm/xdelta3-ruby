# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xdelta3/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "xdelta3-ruby"
  spec.version       = Xdelta3::Ruby::VERSION
  spec.authors       = ["Srdjan Grubor"]
  spec.email         = ["sgnn7@sgnn7.org"]
  spec.summary       = "XDelta3 wrapper for generating patches"
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
end
