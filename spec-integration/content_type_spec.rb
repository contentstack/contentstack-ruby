require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack::ContentType do
  describe "Fetch data from API" do
    before(:context) do
      @data = $STACK.content_types.first
    end

    it "has class as Contentstack::ContentType" do
      expect(@data.class).to eq Contentstack::ContentType
    end

    it "has method called title with data" do
      expect(@data.title).not_to be nil
    end

    it "has method called uid with data" do
      expect(@data.uid).not_to be nil
    end

    it "has method called created_at with data" do
      expect(@data.created_at).not_to be nil
    end

    it "has method called updated_at with data" do
      expect(@data.updated_at).not_to be nil
    end

    it "has method called attributes with data" do
      expect(@data.attributes).not_to be nil
    end
  end

  describe "Initialized using class" do
    before(:context) do
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