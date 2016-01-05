# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crf/version'

Gem::Specification.new do |spec|
  spec.name          = 'crf'
  spec.version       = Crf::VERSION
  spec.authors       = ['Alejandro Bezdjian']
  spec.email         = 'alebezdjian@gmail.com'
  spec.date          = Date.today
  spec.summary       = 'Look for exact duplicated files.'
  spec.description   = 'Library that looks for exact duplicated files.'
  spec.platform      = Gem::Platform::RUBY
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  spec.require_paths = ['lib']
  spec.homepage      = 'https://github.com/alebian/crf'
  spec.license       = 'MIT'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})

  spec.add_dependency 'colorize', '~> 0.7', '>= 0.7.7'
  spec.add_dependency 'ruby-progressbar', '~> 1.7', '>= 1.7.5'

  spec.add_development_dependency 'bundler', '~> 1.10'
end
