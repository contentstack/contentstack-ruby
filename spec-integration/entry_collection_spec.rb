require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::EntryCollection do
  before(:context) do
    @data = $STACK.content_type("category").query.fetch
    @countdata = $STACK.content_type("category").query.include_count.fetch
  end

  it "has no instance variable `count`" do
    expect(@data.count).to be nil
  end

  it "has instance variable `count`" do
    expect(@countdata.count).not_to be nil
  end

  it "has instance variable `entries`" do
    expect(@data.entries).not_to be nil
  end

  it "has the same entry using `first` method" do
    expect(@data.entries[0].uid).to eq @data.first.uid
  end

  it "has the same entry using `last` method" do
    expect(@data.entries[-1].uid).to eq @data.last.uid
  end

  it "has the same entry using `get` method" do
    expect(@data.entries[3].uid).to eq @data.get(3).uid
  end
end