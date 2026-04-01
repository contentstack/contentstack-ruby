lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'contentstack/version'
Gem::Specification.new do |s|
  s.name = %q{contentstack}
  s.version = Contentstack::VERSION.dup
  s.date = Time.now
  s.authors = [%q{Contentstack}]
  s.email = ["support@contentstack.com"]

  # Aligns with nokogiri >= 1.19.x (transitive via contentstack_utils), which requires Ruby >= 3.2.
  s.required_ruby_version = '>= 3.3'

  s.license = "MIT"
  s.homepage = "https://github.com/contentstack/contentstack-ruby"

  s.summary = %q{Contentstack Ruby client for the Content Delivery API}
  s.description = %q{Contentstack Ruby client for the Content Delivery API}

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', '>= 3.2'
  s.add_dependency 'contentstack_utils' , '~> 1.2'
  
  s.add_development_dependency 'rspec', '~> 3.13.0'
  s.add_development_dependency 'webmock', '~> 3.26.0'
  s.add_development_dependency 'simplecov', '~> 0.22.0'
  s.add_development_dependency 'yard', '~> 0.9.38'
end