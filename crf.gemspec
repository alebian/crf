require 'crf/version'

Gem::Specification.new do |s|
  s.name          = 'crf'
  s.version       = Crf::VERSION
  s.date          = '2015-12-02'
  s.summary       = 'Simple library that looks for repeated files.'
  s.description   = 'Simple library that looks for repeated files.'
  s.authors       = ['Alejandro Bezdjian']
  s.email         = 'alebezdjian@gmail.com'
  s.files         = ['lib/crf.rb']
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/alebian/crf'
  s.license       = 'MIT'
  s.executables   << 'crf'
end
