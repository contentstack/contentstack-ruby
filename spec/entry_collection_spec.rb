require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::EntryCollection do
  let(:client) { create_client }
  
  it "has no instance variable `count`" do
    @data = client.content_type("category").query.fetch
    @countdata = client.content_type("category").query.include_count.fetch
    expect(@data.count).to be nil
  end

  it "has instance variable `count`" do
    @data = client.content_type("category").query.fetch
    @countdata = client.content_type("category").query.include_count.fetch
    expect(@countdata.count).not_to be nil
  end

  it "has instance variable `entries`" do
    @data = client.content_type("category").query.fetch
    @countdata = client.content_type("category").query.include_count.fetch
    expect(@data.entries).not_to be nil
  end

  it "has the same entry using `first` method" do
    @data = client.content_type("category").query.fetch
    @countdata = client.content_type("category").query.include_count.fetch
    expect(@data.entries[0].uid).to eq @data.first.uid
  end

  it "has the same entry using `last` method" do
    @data = client.content_type("category").query.fetch
    @countdata = client.content_type("category").query.include_count.fetch
    expect(@data.entries[-1].uid).to eq @data.last.uid
  end

  it "has the same entry using `get` method" do
    @data = client.content_type("category").query.fetch
    @countdata = client.content_type("category").query.include_count.fetch
    expect(@data.entries[3].uid).to eq @data.get(3).uid
  end
end