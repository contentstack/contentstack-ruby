require 'yard'
YARD::Rake::YardocTask.new do |t|
 t.files   = ["README.rdoc", 'lib/contentstack/*.rb', 'lib/contentstack.rb']   # optional
end