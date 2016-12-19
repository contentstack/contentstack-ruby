require 'webmock/rspec'
require 'typhoeus'
require "contentstack"
require 'dotenv'

Dotenv.load
WebMock.disable_net_connect!(allow_localhost: true)

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, /api.github.com/).
         with(:headers => {'Expect'=>'', 'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
         to_return(:status => 200, :body => "", :headers => {})

    stub_request(:get, /cdn.contentstack.io/).
         with(:headers => {'Accept-Encoding'=>'gzip', 'Access-Token'=>'bltbdc42da30987971c', 'Api-Key'=>'blt1c501b5fa4b64377', 'Expect'=>'', 'User-Agent'=>'Typhoeus - https://github.com/typhoeus/typhoeus'}).
         to_return(:status => 200, :body => "", :headers => {})
  end
end

def create_client(access_token: ENV['ACCESS_TOKEN'], api_key: ENV['API_KEY'], environment: ENV['STACK_ENV'])
  Contentstack::Client.new(access_token: access_token, api_key: api_key, environment: environment)
end