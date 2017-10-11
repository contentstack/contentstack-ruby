require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::AssetCollection do
  it "has attribute called `assets`" do
    data = $STACK.assets.fetch
    expect(data.assets).not_to be nil
  end

  it "is instance of `Contentstack::AssetCollection`" do
    data = $STACK.assets.fetch
    expect(data.class).to be Contentstack::AssetCollection
  end
end