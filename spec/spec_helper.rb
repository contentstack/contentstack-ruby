$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'rspec'
require "contentstack"

def create_client(access_token: :foo, access_key: :bar, environment: :baz)
  Contentstack::Client.new(access_token: access_token, access_key: access_key, environment: environment)
end