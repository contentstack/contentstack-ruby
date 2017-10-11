require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::Asset do
  before(:context) do
    @uid = "blt3ca1a3470787ba63"
    @asset = $STACK.asset(@uid).fetch
  end

  it "has attribute called `uid`" do
    expect(@asset.uid).not_to be nil
  end

  it "should match uid" do
    expect(@asset.uid).to eq @uid
  end

  it "has attribute called `url`" do
    expect(@asset.url).not_to be nil
  end

  it "has attribute called `tags`" do
    expect(@asset.tags).not_to be nil
  end

  it "has attribute called `file_size`" do
    expect(@asset.file_size).not_to be nil
  end

  it "has attribute called `filename`" do
    expect(@asset.filename).not_to be nil
  end

  it "has attribute called `content_type`" do
    expect(@asset.content_type).not_to be nil
  end
end