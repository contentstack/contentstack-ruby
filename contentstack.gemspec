# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contentstack/version'

Gem::Specification.new do |spec|
  spec.name          = "contentstack"
  spec.version       = Contentstack::VERSION
  spec.authors       = ["amite"]
  spec.email         = ["amit.erandole@gmail.com"]

  spec.summary       = %q{A ruby gem to work with contentstack.built.io}
  spec.description   = %q{A ruby gem to work with the Content Delivery API for contentstack.built.io}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'typhoeus', '~> 1.1', '>= 1.1.2'
  spec.add_dependency 'multi_json', '~> 1.12', '>= 1.12.1'

  spec.add_development_dependency 'bundler', '~> 1.13', '>= 1.13.6'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'webmock', '~> 2.3', '>= 2.3.1'
  spec.add_development_dependency 'dotenv', '~> 2.1', '>= 2.1.1'
  spec.add_development_dependency 'yard'
end
