require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::Asset do
  let(:client) { create_client }

  it "has attribute called `uid`" do
    @uid = "blt3ca1a3470787ba63"
    @asset = client.asset(@uid).fetch
    expect(@asset.uid).not_to be nil
  end

  it "should match uid" do
    @uid = "blt3ca1a3470787ba63"
    @asset = client.asset(@uid).fetch
    expect(@asset.uid).to eq @uid
  end

  it "has attribute called `url`" do
    @uid = "blt3ca1a3470787ba63"
    @asset = client.asset(@uid).fetch
    expect(@asset.url).not_to be nil
  end

  it "has attribute called `tags`" do
    @uid = "blt3ca1a3470787ba63"
    @asset = client.asset(@uid).fetch
    expect(@asset.tags).not_to be nil
  end

  it "has attribute called `file_size`" do
    @uid = "blt3ca1a3470787ba63"
    @asset = client.asset(@uid).fetch
    expect(@asset.file_size).not_to be nil
  end

  it "has attribute called `filename`" do
    @uid = "blt3ca1a3470787ba63"
    @asset = client.asset(@uid).fetch
    expect(@asset.filename).not_to be nil
  end

  it "has attribute called `content_type`" do
    @uid = "blt3ca1a3470787ba63"
    @asset = client.asset(@uid).fetch
    expect(@asset.content_type).not_to be nil
  end
end