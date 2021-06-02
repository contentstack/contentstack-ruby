lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'contentstack/version'
Gem::Specification.new do |s|
  s.name = %q{contentstack}
  s.version = Contentstack::VERSION.dup
  s.date = Time.now
  s.authors = [%q{Contentstack}]
  s.email = ["support@contentstack.com"]

  s.required_ruby_version = '>= 2.0'

  s.license = "MIT"
  s.homepage = "https://github.com/contentstack/contentstack-ruby"

  s.summary = %q{Contentstack Ruby client for the Content Delivery API}
  s.description = %q{Contentstack Ruby client for the Content Delivery API}

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', '>= 3.2', '< 6.2'
  s.add_dependency "contentstack_utils", '~> 1.0', '>= 1.0.1'
  
  s.add_development_dependency 'rspec', '~> 3.10.0'
  s.add_development_dependency 'webmock', '~> 3.11.0'
  s.add_development_dependency 'simplecov', '~> 0.21.1'
  s.add_development_dependency 'yard', '~> 0.9.26'
end