require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::Entry do
  let(:client) { create_client }
  let(:preview_client) { create_preview_client }
  let(:uid) { "uid" }
  let(:category) {client.content_type("category").entry(uid)}
  let(:preview_category) {preview_client.content_type("category").entry(uid)}
  let(:product) {client.content_type("product").entry(uid)}

  it "Contentstack::EntryCollection should have Contentstack::Entry instance" do
    data = client.content_type("category").query.fetch
    expect(data.class).to eq Contentstack::EntryCollection
    expect(data.first.class).to eq Contentstack::Entry
  end

  it "is an instance of Contentstack::Entry if single entry is fetched" do
    data = category.fetch
    expect(data.class).to eq Contentstack::Entry
  end

  it "is preview entry featch" do
    preview_client.live_preview_query({hash: 'hash', content_type_uid: 'category'})
    data = preview_category.fetch
    expect(data.class).to eq Contentstack::Entry
  end

  it 'has a method `get` to get attributes data' do
    data = category.fetch
    expect(data.get('uid')).to eq uid
  end

  it "should set locale the in the request entry" do
    data = category.locale('en-us')
    expect(data.query[:locale]).to eq 'en-us'
  end

  it "should get data using `only` method with string parameter" do
    data = category.fetch
    expect(data.fields[:title]).not_to be nil
    expect(data.fields[:uid]).not_to be nil
  end

  it "should get data using `only` method with array parameter" do
    data = category.only(["title"]).fetch
    expect(data.fields[:title]).not_to be nil
    expect(data.fields[:uid]).not_to be nil
  end

  it "should get data using `except` method with string parameter" do
    data = category.except("category_tags").fetch
    expect(data.fields[:category_tags]).to be nil
  end

  it "should get data using `except` method with array parameter" do
    data = category.except(["description"]).fetch
    expect(data.fields[:description]).to be nil
  end

  it "should get data using `only` method for reference fields" do
    data = product.include_reference('categories').only("categories", ["title", "description"]).fetch
    expect(data.fields[:categories][0][:title]).to eq "Smartphones"
  end

  it "should get data using `except` method for reference fields" do
    data = product.include_reference('categories').except("categories", "title").fetch
    expect(data.fields[:categories][0][:title]).to eq 'Smartphones'
  end
  
  it "should get data using `include_schema` method" do
    data = category.include_schema.fetch
    expect(data.schema).not_to be nil
  end

  it "should get data using `include_owner` method" do
    data = product.include_owner.fetch
    expect(data.fields[:_owner]).not_to be nil
  end

  it "should get data using `include_owner` method" do
    data = product.include_fallback.fetch
    expect(data.fields[:locale]).not_to be nil
  end

  it "should get data using `include_content_type` method" do
    data = category.include_content_type.fetch
    expect(data.content_type).not_to be nil
  end
  
  it "should get data using `include_reference` method" do
    data = product.include_reference('categories').fetch
    puts data.get("categories.title")
    expect(data.fields[:categories][0][:title]).not_to be nil
  end

  it "should get data using `include_embedded_items` method" do
    data = product.include_embedded_items().fetch
    puts data.get("categories.title")
    expect(data.fields[:categories][0][:title]).not_to be nil
  end
end