require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::ContentType do
  let(:client) { create_client }
  let(:eu_client) { create_client('DELIVERY_TOKEN', 'API_KEY', 'STACK_ENV', {region: Contentstack::Region::EU}) }
  let(:custom_host_client) { create_client('DELIVERY_TOKEN', 'API_KEY', 'STACK_ENV', {host: "https://custom-cdn.contentstack.com"}) }

  describe "Fetch data from API" do
    it "has class as Contentstack::ContentType" do
      @data = client.content_types.first
      expect(@data.class).to eq Contentstack::ContentType
    end

    it "has method called title with data" do
      @data = client.content_types.first
      expect(@data.title).not_to be nil
    end
    
    it "has method called title with data from eu" do
      @data = eu_client.content_types.first
      expect(@data.title).not_to be nil
    end

    it "has method called title with data from custom client" do
      @data = custom_host_client.content_types.first
      expect(@data.title).not_to be nil
    end

    it "has method called uid with data" do
      @data = client.content_types.first
      expect(@data.uid).not_to be nil
    end

    it "has method called created_at with data" do
      @data = client.content_types.first
      expect(@data.created_at).not_to be nil
    end

    it "has method called updated_at with data" do
      @data = client.content_types.first
      expect(@data.updated_at).not_to be nil
    end

    it "has method called attributes with data" do
      @data = client.content_types.first
      expect(@data.attributes).not_to be nil
    end

    it "Should get content type from uid" do
      @data = client.content_type("category").fetch
      expect(@data.attributes).not_to be nil
    end
  end

  describe "Initialized using class" do
    before(:each) do
      @data = Contentstack::ContentType.new({uid: "DummyUID"})
    end
    
    it "has method called title without data" do
      expect(@data.title).to be nil
    end

    it "has method called uid with data" do
      expect(@data.uid).not_to be nil
    end

    it "has method called created_at without data" do
      expect(@data.created_at).to be nil
    end

    it "has method called updated_at without data" do
      expect(@data.updated_at).to be nil
    end

    it "has method called attributes without data" do
      expect(@data.attributes).not_to be nil
    end
  end
end