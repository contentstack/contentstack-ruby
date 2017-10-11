require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::ContentType do
  let(:client) { create_client }

  describe "Fetch data from API" do
    it "has class as Contentstack::ContentType" do
      @data = client.content_types.first
      expect(@data.class).to eq Contentstack::ContentType
    end

    it "has method called title with data" do
      @data = client.content_types.first
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