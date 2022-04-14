require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::Query do
  let(:client) { create_client }
  let(:preview_client) { create_preview_client }
  let(:category_query) {client.content_type("category").query}
  let(:preview_category) {preview_client.content_type("category").query}
  let(:product_query) {client.content_type("product").query}

  it "should get data using `where` method" do
    data = category_query.where({title: "Electronics"}).fetch
    expect(data.length).to eq 5
  end

  it "should get data using `regex` method" do
    data = category_query.regex("title", "App.*").fetch
    expect(data.length).to eq 5
  end

  it "is preview entry featch" do
    preview_client.live_preview_query({hash: 'hash', content_type_uid: 'category'})
    data = preview_category.fetch
    expect(data.length).to eq 5
  end

  it "should get data using `less_than` method" do
    data = product_query.less_than("price", 150).fetch
    expect(data.length).to eq 3
  end

  it "should get data using `less_than_or_equal` method" do
    data = product_query.less_than_or_equal("price", 166).fetch
    expect(data.length).to eq 3
  end
  
  it "should get data using `greater_than` method" do
    data = product_query.greater_than("price", 120).fetch
    expect(data.length).to eq 3
  end

  it "should get data using `greater_than_or_equal` method" do
    data = product_query.greater_than_or_equal("price", 166).fetch
    expect(data.length).to eq 3
  end

  it "should get data using `not_equal_to` method" do
    data = product_query.not_equal_to("price", 166).fetch
    expect(data.length).to eq 3
  end
  
  it "should get data using `limit` method" do
    data = category_query.limit(2).fetch
    expect(data.length).to eq 5
  end

  it "should get data using `skip` method" do
    data = category_query.skip(5).fetch
    expect(data.length).to eq 5
  end

  it "should get data using `include_count` method" do
    data = category_query.include_count.fetch
    expect(data.count).not_to be nil
    expect(data.count).to eq 5
  end

  it "should get data using `only` method with string parameter" do
    data = category_query.only("title").fetch
    expect(data.first.fields[:title]).not_to be nil
    expect(data.first.fields[:uid]).not_to be nil
  end

  it "should get data using `only` method with array parameter" do
    data = category_query.only(["title"]).fetch
    expect(data.first.fields[:title]).not_to be nil
    expect(data.first.fields[:uid]).not_to be nil
  end

  it "should get data using `except` method with string parameter" do
    data = category_query.except("category_tags").fetch
    expect(data.first.fields[:category_tags]).to be nil
  end

  it "should get data using `except` method with array parameter" do
    data = category_query.except(["description"]).fetch
    expect(data.first.fields[:description]).to be nil
  end

  it "should get data using `tags` method" do
    data = category_query.tags(["tag1"]).fetch
    expect(data.length).to eq 5
  end

  it "should get data using `contained_in` method" do
    data = category_query.contained_in("title", ["Electronics", "Apparel"]).fetch
    expect(data.length).to eq 5
    expect(data.first.fields[:title]).to eq "Home & Appliances"
    expect(data.last.fields[:title]).to eq "Headphones"
  end

  it "should get data using `not_contained_in` method" do
    data = category_query.not_contained_in("title", ["Electronics", "Apparel"]).fetch
    expect(data.length).to eq 5
  end
  
  it "should get data using `in` method" do
    data = category_query.contained_in("title", ["Electronics", "Apparel"]).fetch
    expect(data.length).to eq 5
  end

  it "should get data using `not_in` method" do
    data = category_query.not_contained_in("title", ["Electronics", "Apparel"]).fetch
    expect(data.length).to eq 5
  end

  it "should get data using `ascending` method" do
    data = product_query.ascending("price").fetch
    expect(data.first.fields[:title]).to eq "Motorola Moto X4"
  end

  it "should get data using `descending` method" do
    data = product_query.descending("price").fetch
    expect(data.first.fields[:title]).to eq "Motorola Moto X4"
  end

  it "should get data using `only` method for reference fields" do
    data = product_query.include_reference('categories').only("categories", ["title", "description"]).fetch
    expect(data.first.fields[:categories][0][:title]).to eq "Smartphones"
  end

  it "should get data using `except` method for reference fields" do
    data = product_query.include_reference('categories').except("categories", "title").fetch
    expect(data.first.fields[:categories][0][:title]).to eq 'Smartphones'
  end
  
  it "should get data using `include_schema` method" do
    data = category_query.include_schema.fetch
    expect(data.schema).not_to be nil
  end

  it "should get data using `include_content_type` method" do
    data = category_query.include_content_type.fetch
    expect(data.content_type).not_to be nil
  end
  
  it "should get data using `include_reference` method" do
    data = product_query.include_reference('categories').fetch
    puts data.first.get("categories.title")
    expect(data.first.fields[:categories][0][:title]).not_to be nil
  end
  
  it "should get data using `include_owner` method" do
    data = product_query.include_owner.fetch
    expect(data.first.fields[:_owner]).not_to be nil
  end
  
  it "should get data using `include_owner` method" do
    data = product_query.include_fallback.fetch
    expect(data.first.fields[:locale]).not_to be nil
  end

  it "should get data using `include_draft` method" do
    data = category_query.include_draft.fetch
    expect(data.length).to eq 5
  end

  it "should get data using `search` method" do
    data = category_query.search("App").fetch
    expect(data.length).to eq 5
  end

  it "should get data using `count` method" do
    data = category_query.count
    expect(data).to eq 5
  end

  it "should get data using `exists` method" do
    data = category_query.exists?('description').fetch
    expect(data.length).to eq 5
  end
  
  it "should get data using `not_exists` method" do
    data = product_query.not_exists?('banner_image').fetch
    expect(data.length).to eq 3
  end

  it "should get data using `and` method" do
    q1 = client.content_type("category").query.regex("title", "App.*")
    q2 = client.content_type("category").query.where({"description"=>"Appliances Category"})
    data = category_query.and([q1,q2]).fetch
    expect(data.length).to eq 5
  end

  it "should get data using `or` method" do
    q1 = client.content_type("category").query.regex("title", "App.*")
    q2 = client.content_type("category").query.regex("description", "App*")
    data = category_query.or([q1,q2]).fetch
    expect(data.length).to eq 5
  end

  it "should set locale the in the request query" do
    data =  product_query.locale('en-us')
    expect(data.query[:locale]).to eq 'en-us'
  end
end