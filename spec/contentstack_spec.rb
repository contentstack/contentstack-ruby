require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack do
  let(:client) { create_client }

  it "has a version number" do
    expect(Contentstack::VERSION).not_to be nil
  end
end