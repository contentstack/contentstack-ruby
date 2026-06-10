require 'spec_helper'
require_relative '../lib/contentstack'

describe Contentstack::Endpoint do
  let(:regions_data) do
    JSON.parse(File.read(Contentstack::Endpoint::DATA_FILE_PATH))
  end

  # ---------------------------------------------------------------------------
  # CDA endpoints (default service)
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - CDA (default)' do
    {
      'us'       => 'https://cdn.contentstack.io',
      'eu'       => 'https://eu-cdn.contentstack.com',
      'azure-na' => 'https://azure-na-cdn.contentstack.com',
      'azure-eu' => 'https://azure-eu-cdn.contentstack.com',
      'gcp-na'   => 'https://gcp-na-cdn.contentstack.com',
      'gcp-eu'   => 'https://gcp-eu-cdn.contentstack.com'
    }.each do |region, expected_url|
      it "resolves #{region} CDA to #{expected_url}" do
        expect(described_class.get_contentstack_endpoint(region)).to eq expected_url
      end
    end
  end

  # ---------------------------------------------------------------------------
  # CMA endpoints
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - CMA' do
    {
      'us'       => 'https://api.contentstack.io',
      'eu'       => 'https://eu-api.contentstack.com',
      'azure-na' => 'https://azure-na-api.contentstack.com',
      'azure-eu' => 'https://azure-eu-api.contentstack.com',
      'gcp-na'   => 'https://gcp-na-api.contentstack.com',
      'gcp-eu'   => 'https://gcp-eu-api.contentstack.com'
    }.each do |region, expected_url|
      it "resolves #{region} CMA to #{expected_url}" do
        expect(described_class.get_contentstack_endpoint(region, 'cma')).to eq expected_url
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Preview endpoints
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - Preview' do
    {
      'us'       => 'https://preview.contentstack.io',
      'eu'       => 'https://eu-preview.contentstack.com',
      'azure-na' => 'https://azure-na-preview.contentstack.com',
      'azure-eu' => 'https://azure-eu-preview.contentstack.com',
      'gcp-na'   => 'https://gcp-na-preview.contentstack.com',
      'gcp-eu'   => 'https://gcp-eu-preview.contentstack.com'
    }.each do |region, expected_url|
      it "resolves #{region} preview to #{expected_url}" do
        expect(described_class.get_contentstack_endpoint(region, 'preview')).to eq expected_url
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Service constants on Contentstack::Service
  # ---------------------------------------------------------------------------
  describe 'Contentstack::Service constants' do
    it 'defines CDA' do
      expect(Contentstack::Service::CDA).to eq 'cda'
    end

    it 'defines CMA' do
      expect(Contentstack::Service::CMA).to eq 'cma'
    end

    it 'defines PREVIEW' do
      expect(Contentstack::Service::PREVIEW).to eq 'preview'
    end
  end

  # ---------------------------------------------------------------------------
  # Region constants on Contentstack::Region
  # ---------------------------------------------------------------------------
  describe 'Contentstack::Region constants' do
    it 'includes GCP_EU' do
      expect(Contentstack::Region::GCP_EU).to eq 'gcp-eu'
    end
  end

  # ---------------------------------------------------------------------------
  # Custom host resolution
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - custom host' do
    it 'prepends the correct CDN prefix for eu + custom host' do
      expect(described_class.get_contentstack_endpoint('eu', 'cda', 'example.com'))
        .to eq 'https://eu-cdn.example.com'
    end

    it 'prepends the correct CDN prefix for azure-na + custom host' do
      expect(described_class.get_contentstack_endpoint('azure-na', 'cda', 'example.com'))
        .to eq 'https://azure-na-cdn.example.com'
    end

    it 'prepends the correct CDN prefix for gcp-eu + custom host' do
      expect(described_class.get_contentstack_endpoint('gcp-eu', 'cda', 'example.com'))
        .to eq 'https://gcp-eu-cdn.example.com'
    end

    it 'falls back to cdn. prefix for an unknown region + custom host' do
      expect(described_class.get_contentstack_endpoint('unknown-region', 'cda', 'example.com'))
        .to eq 'https://cdn.example.com'
    end
  end

  # ---------------------------------------------------------------------------
  # Error handling
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - error handling' do
    it 'raises Contentstack::Error for an unknown region (no custom host)' do
      expect { described_class.get_contentstack_endpoint('mars') }
        .to raise_error(Contentstack::Error, /Unknown region 'mars'/)
    end

    it 'raises Contentstack::Error for an unknown service' do
      expect { described_class.get_contentstack_endpoint('us', 'graphql') }
        .to raise_error(Contentstack::Error, /Unknown service 'graphql'/)
    end
  end

  # ---------------------------------------------------------------------------
  # Runtime fallback when regions.json is absent
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - runtime fallback' do
    it 'fetches from registry when regions.json is absent and caches it' do
      stub_request(:get, Contentstack::Endpoint::REGISTRY_URL)
        .to_return(status: 200, body: regions_data.to_json, headers: {})

      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(Contentstack::Endpoint::DATA_FILE_PATH).and_return(false)
      allow(File).to receive(:write).and_call_original

      result = described_class.get_contentstack_endpoint('eu')
      expect(result).to eq 'https://eu-cdn.contentstack.com'
    end
  end

  # ---------------------------------------------------------------------------
  # refresh_regions
  # ---------------------------------------------------------------------------
  describe '.refresh_regions' do
    it 'writes updated region data to DATA_FILE_PATH' do
      stub_request(:get, Contentstack::Endpoint::REGISTRY_URL)
        .to_return(status: 200, body: regions_data.to_json, headers: {})

      allow(FileUtils).to receive(:mkdir_p)
      expect(File).to receive(:write).with(
        Contentstack::Endpoint::DATA_FILE_PATH,
        JSON.pretty_generate(regions_data)
      )

      result = described_class.refresh_regions
      expect(result).to eq regions_data
    end

    it 'raises Contentstack::Error when registry returns non-200' do
      stub_request(:get, Contentstack::Endpoint::REGISTRY_URL)
        .to_return(status: 503, body: 'Service Unavailable')

      expect { described_class.refresh_regions }
        .to raise_error(Contentstack::Error, /HTTP 503/)
    end
  end

  # ---------------------------------------------------------------------------
  # Module-level proxy: Contentstack.get_contentstack_endpoint
  # ---------------------------------------------------------------------------
  describe 'Contentstack.get_contentstack_endpoint' do
    it 'proxies to Endpoint and returns the correct CDA URL for US' do
      expect(Contentstack.get_contentstack_endpoint('us')).to eq 'https://cdn.contentstack.io'
    end

    it 'proxies to Endpoint and returns the correct CMA URL for EU' do
      expect(Contentstack.get_contentstack_endpoint('eu', 'cma')).to eq 'https://eu-api.contentstack.com'
    end
  end
end
