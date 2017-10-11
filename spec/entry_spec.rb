require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::Entry do
  let(:client) { create_client }

  it "Contentstack::EntryCollection should have Contentstack::Entry instance" do
    data = client.content_type("category").query.fetch
    expect(data.class).to eq Contentstack::EntryCollection
    expect(data.first.class).to eq Contentstack::Entry
  end

  it "is an instance of Contentstack::Entry if single entry is fetched" do
    data = client.content_type("category").entry("blt05056a2f5e0ebf76").fetch
    expect(data.class).to eq Contentstack::Entry
  end

  it 'has a method `get` to get attributes data' do
    uid = "blt05056a2f5e0ebf76"
    data = client.content_type("category").entry(uid).fetch
    expect(data.get('uid')).to eq uid
  end
end