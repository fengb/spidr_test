# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spidr_test/version'

Gem::Specification.new do |spec|
  spec.name          = 'spidr_test'
  spec.version       = SpidrTest::VERSION
  spec.authors       = ['fengb']
  spec.email         = ['contact@fengb.info']

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'spidr', '~> 0.4.0'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'cucumber', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'sinatra', '~> 1.4.6'
end
