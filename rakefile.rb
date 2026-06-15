require 'yard'
YARD::Rake::YardocTask.new do |t|
  t.files = ["README.rdoc", 'lib/contentstack/*.rb', 'lib/contentstack.rb']
end

desc 'Download the latest region metadata from the Contentstack registry and update lib/data/regions.json'
task :refresh_regions do
  require_relative 'lib/contentstack/endpoint'
  require_relative 'lib/contentstack/error'
  puts 'Fetching latest region metadata from registry...'
  Contentstack::Endpoint.refresh_regions
  puts "regions.json updated at: #{Contentstack::Endpoint::DATA_FILE_PATH}"
end