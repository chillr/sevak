# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sevak/version'

Gem::Specification.new do |spec|
  spec.name          = 'sevak'
  spec.version       = Sevak::VERSION
  spec.authors       = ['Deepak Kumar']
  spec.email         = ['deepakkumarnd@gmail.com']

  spec.summary       = %q{Create rabbitmq consumers}
  spec.description   = %q{Sevak lets you easily add consumers in your rails app}
  spec.homepage      = 'https://github.com/chillr/sevak'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_runtime_dependency 'bunny', '~> 2.7'

  # spec.add_development_dependency 'bundler', '~> 1.9'
  # spec.add_development_dependency 'rake', '~> 10.0'
end
