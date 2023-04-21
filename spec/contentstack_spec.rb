require 'spec_helper'
require_relative '../lib/contentstack.rb'

describe Contentstack do
  let(:client) { create_client }
  let(:eu_client) { create_client('DELIVERY_TOKEN_TOKEN', 'API_KEY', 'STACK_ENV', {region: Contentstack::Region::EU}) }
  let(:azure_na_client) { create_client('DELIVERY_TOKEN_TOKEN', 'API_KEY', 'STACK_ENV', {region: Contentstack::Region::AZURE_NA}) }
  let(:azure_eu_client) { create_client('DELIVERY_TOKEN_TOKEN', 'API_KEY', 'STACK_ENV', {region: Contentstack::Region::AZURE_EU}) }
  let(:custom_host_eu_client) { create_client('DELIVERY_TOKEN_TOKEN', 'API_KEY', 'STACK_ENV', {host: "contentstack.com", region: Contentstack::Region::EU}) }
  let(:custom_host_azure_eu_client) { create_client('DELIVERY_TOKEN_TOKEN', 'API_KEY', 'STACK_ENV', {host: "contentstack.com", region: Contentstack::Region::AZURE_EU}) }
  let(:custom_host_azure_na_client) { create_client('DELIVERY_TOKEN_TOKEN', 'API_KEY', 'STACK_ENV', {host: "contentstack.com", region: Contentstack::Region::AZURE_NA}) }

  it "has a version number" do
    expect(Contentstack::VERSION).not_to be nil
  end

  it "has region data" do
    expect(Contentstack::Region::EU).not_to be 'eu'
    expect(Contentstack::Region::US).not_to be 'us'
    expect(Contentstack::Region::AZURE_NA).not_to be 'azure-na'
    expect(Contentstack::Region::AZURE_EU).not_to be 'azure-eu'
  end

  it "has default host and region" do
    expect(client.region).to eq Contentstack::Region::US
    expect(client.host).to eq 'https://cdn.contentstack.io'  
  end

  it "has custom region with region host" do
    expect(eu_client.region).to eq Contentstack::Region::EU
    expect(eu_client.host).to eq 'https://eu-cdn.contentstack.com'  
  end

  it "has custom region with region host" do
    expect(azure_na_client.region).to eq Contentstack::Region::AZURE_NA
    expect(azure_na_client.host).to eq 'https://azure-na-cdn.contentstack.com'  
  end

  it "has custom region with region host" do
    expect(azure_eu_client.region).to eq Contentstack::Region::AZURE_EU
    expect(azure_eu_client.host).to eq 'https://azure-eu-cdn.contentstack.com'  
  end

  it "has custom host and eu region" do
    expect(custom_host_eu_client.host).to eq 'https://eu-cdn.contentstack.com'  
  end

  it "has custom host and azure-eu region" do
    expect(custom_host_azure_eu_client.host).to eq 'https://azure-eu-cdn.contentstack.com'  
  end

  it "has custom host and azure-na region" do
    expect(custom_host_azure_na_client.host).to eq 'https://azure-na-cdn.contentstack.com'  
  end


  it "JSON to HTML" do
    expect(Contentstack::json_to_html({}, ContentstackUtils::Model::Options.new())).to eq ''  
  end

  it "JSON to HTML" do
    expect(Contentstack::render_content('', ContentstackUtils::Model::Options.new())).to eq ''  
  end
end