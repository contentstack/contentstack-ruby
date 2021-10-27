require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::AssetCollection do
  let(:client) { create_client }

  it "has attribute called `assets`" do
    data = client.assets.fetch
    expect(data.assets).not_to be nil
  end

  it "is instance of `Contentstack::AssetCollection`" do
    data = client.assets.fetch
    expect(data.class).to be Contentstack::AssetCollection
  end
end