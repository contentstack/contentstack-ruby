lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'contentstack/version'
Gem::Specification.new do |s|
  s.name = %q{contentstack}
  s.version = Contentstack::VERSION.dup
  s.date = Time.now
  s.authors = [%q{Rohit Sharma}]
  s.email = ["rubygems@contentstack.com"]

  s.license = "MIT"
  s.homepage = "https://github.com/builtio-contentstack/contentstack-ruby"

  s.summary = %q{Contentstack Ruby client for the Content Delivery API}
  s.description = %q{Contentstack Ruby client for the Content Delivery API}

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', "> 3.2.5"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'simplecov'
end