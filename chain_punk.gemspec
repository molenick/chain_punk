lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chain_punk/version'

Gem::Specification.new do |spec|
  spec.name          = 'chain_punk'
  spec.version       = ChainPunk::VERSION
  spec.authors       = ['Matt Olenick']
  spec.email         = ['matt.olenick@gmail.com']
  spec.homepage      = 'https://github.com/molenick/chain_punk'
  spec.license       = 'MIT'
  spec.summary       = 'Generate text from configurable patterns.'
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.2.33'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.65'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.32'
end
