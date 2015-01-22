# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proquint/version'

Gem::Specification.new do |spec|
  spec.name          = "proquint"
  spec.version       = Proquint::VERSION
  spec.authors       = ["JJ Buckley"]
  spec.email         = ["jj@bjjb.org"]
  spec.summary       = %q{Readable, spellable, pronounceable identifiers}
  spec.homepage      = "http://bjjb.github.io/proquint"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.4.3"
end
