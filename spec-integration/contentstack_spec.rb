require 'spec_helper'
require_relative '../lib/contentstack.rb'

$STACK = Contentstack::Client.new(ENV['api_key'], ENV['access_token'], ENV['environment'])

describe Contentstack do
  it "has a version number" do
    expect(Contentstack::VERSION).not_to be nil
  end
end