require 'net/http'
require 'uri'
require 'json'
require 'fileutils'

REGISTRY_URL = 'https://artifacts.contentstack.com/regions.json'

gem_root  = File.expand_path('../..', __dir__)
data_dir  = File.join(gem_root, 'lib', 'data')
dest_file = File.join(data_dir, 'regions.json')

FileUtils.mkdir_p(data_dir)

begin
  uri      = URI.parse(REGISTRY_URL)
  response = Net::HTTP.get_response(uri)
  if response.is_a?(Net::HTTPSuccess)
    File.write(dest_file, JSON.pretty_generate(JSON.parse(response.body)))
    $stdout.puts "[Contentstack] regions.json downloaded successfully."
  else
    $stdout.puts "[Contentstack] Warning: Could not download regions.json (HTTP #{response.code}). Runtime fallback will be used."
  end
rescue => e
  $stdout.puts "[Contentstack] Warning: Could not download regions.json — #{e.message}. Runtime fallback will be used."
end

# RubyGems requires a Makefile to exist after extconf.rb runs.
# We create a no-op one since this extension has no C code to compile.
File.write('Makefile', "all:\n\ninstall:\n\nclean:\n\n")
