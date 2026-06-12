require 'spec_helper'
require_relative '../lib/contentstack'

describe Contentstack::Endpoint do
  let(:regions_data) do
    JSON.parse(File.read(Contentstack::Endpoint::DATA_FILE_PATH))
  end

  # ---------------------------------------------------------------------------
  # contentDelivery (CDA) endpoints — default service
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - contentDelivery (default)' do
    {
      'us'       => 'https://cdn.contentstack.io',
      'na'       => 'https://cdn.contentstack.io',
      'eu'       => 'https://eu-cdn.contentstack.com',
      'au'       => 'https://au-cdn.contentstack.com',
      'azure-na' => 'https://azure-na-cdn.contentstack.com',
      'azure-eu' => 'https://azure-eu-cdn.contentstack.com',
      'gcp-na'   => 'https://gcp-na-cdn.contentstack.com',
      'gcp-eu'   => 'https://gcp-eu-cdn.contentstack.com'
    }.each do |region, expected|
      it "resolves #{region} => #{expected}" do
        expect(described_class.get_contentstack_endpoint(region)).to eq expected
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Short alias 'cda' backward-compat via SERVICE_MAP
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - short alias cda' do
    it "maps 'cda' to contentDelivery" do
      expect(described_class.get_contentstack_endpoint('eu', 'cda'))
        .to eq 'https://eu-cdn.contentstack.com'
    end

    it "maps 'cma' to contentManagement" do
      expect(described_class.get_contentstack_endpoint('eu', 'cma'))
        .to eq 'https://eu-api.contentstack.com'
    end
  end

  # ---------------------------------------------------------------------------
  # contentManagement (CMA) endpoints
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - contentManagement' do
    {
      'us'       => 'https://api.contentstack.io',
      'eu'       => 'https://eu-api.contentstack.com',
      'au'       => 'https://au-api.contentstack.com',
      'azure-na' => 'https://azure-na-api.contentstack.com',
      'azure-eu' => 'https://azure-eu-api.contentstack.com',
      'gcp-na'   => 'https://gcp-na-api.contentstack.com',
      'gcp-eu'   => 'https://gcp-eu-api.contentstack.com'
    }.each do |region, expected|
      it "resolves #{region} CMA => #{expected}" do
        expect(described_class.get_contentstack_endpoint(region, 'contentManagement')).to eq expected
      end
    end
  end

  # ---------------------------------------------------------------------------
  # All other services for a representative region (EU)
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - all services for EU' do
    {
      'auth'                 => 'https://eu-auth-api.contentstack.com',
      'graphqlDelivery'      => 'https://eu-graphql.contentstack.com',
      'preview'              => 'https://eu-rest-preview.contentstack.com',
      'graphqlPreview'       => 'https://eu-graphql-preview.contentstack.com',
      'images'               => 'https://eu-images.contentstack.com',
      'assets'               => 'https://eu-assets.contentstack.com',
      'automate'             => 'https://eu-prod-automations-api.contentstack.com',
      'launch'               => 'https://eu-launch-api.contentstack.com',
      'developerHub'         => 'https://eu-developerhub-api.contentstack.com',
      'brandKit'             => 'https://eu-brand-kits-api.contentstack.com',
      'genAI'                => 'https://eu-ai.contentstack.com/brand-kits',
      'personalizeManagement'=> 'https://eu-personalize-api.contentstack.com',
      'personalizeEdge'      => 'https://eu-personalize-edge.contentstack.com',
      'composableStudio'     => 'https://eu-composable-studio-api.contentstack.com',
      'application'          => 'https://eu-app.contentstack.com'
    }.each do |service, expected|
      it "resolves EU #{service} => #{expected}" do
        expect(described_class.get_contentstack_endpoint('eu', service)).to eq expected
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Region::Service constants
  # ---------------------------------------------------------------------------
  describe 'Contentstack::Service constants' do
    it 'CDA aliases to contentDelivery'   do expect(Contentstack::Service::CDA).to eq 'contentDelivery'   end
    it 'CMA aliases to contentManagement' do expect(Contentstack::Service::CMA).to eq 'contentManagement' end
    it 'defines PREVIEW'                  do expect(Contentstack::Service::PREVIEW).to eq 'preview'        end
    it 'defines AUTH'                     do expect(Contentstack::Service::AUTH).to eq 'auth'               end
    it 'defines GRAPHQL_DELIVERY'         do expect(Contentstack::Service::GRAPHQL_DELIVERY).to eq 'graphqlDelivery' end
    it 'defines IMAGES'                   do expect(Contentstack::Service::IMAGES).to eq 'images'           end
    it 'defines ASSETS'                   do expect(Contentstack::Service::ASSETS).to eq 'assets'           end
    it 'defines DEVELOPER_HUB'            do expect(Contentstack::Service::DEVELOPER_HUB).to eq 'developerHub' end
    it 'defines GEN_AI'                   do expect(Contentstack::Service::GEN_AI).to eq 'genAI'            end
  end

  # ---------------------------------------------------------------------------
  # Region constants
  # ---------------------------------------------------------------------------
  describe 'Contentstack::Region constants' do
    it 'includes AU'     do expect(Contentstack::Region::AU).to eq 'au'       end
    it 'includes GCP_EU' do expect(Contentstack::Region::GCP_EU).to eq 'gcp-eu' end
  end

  # ---------------------------------------------------------------------------
  # Alias resolution (aliases come from regions.json itself)
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - region aliases from regions.json' do
    it "resolves 'aws-na' (alias) to the NA CDN" do
      expect(described_class.get_contentstack_endpoint('aws-na')).to eq 'https://cdn.contentstack.io'
    end

    it "resolves 'aws-eu' (alias) to the EU CDN" do
      expect(described_class.get_contentstack_endpoint('aws-eu')).to eq 'https://eu-cdn.contentstack.com'
    end

    it "resolves 'aws-au' (alias) to the AU CDN" do
      expect(described_class.get_contentstack_endpoint('aws-au')).to eq 'https://au-cdn.contentstack.com'
    end
  end

  # ---------------------------------------------------------------------------
  # Custom host resolution
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - custom host' do
    it 'prepends eu-cdn prefix for eu + custom host' do
      expect(described_class.get_contentstack_endpoint('eu', 'contentDelivery', 'example.com'))
        .to eq 'https://eu-cdn.example.com'
    end

    it 'prepends azure-na-cdn prefix for azure-na + custom host' do
      expect(described_class.get_contentstack_endpoint('azure-na', 'contentDelivery', 'example.com'))
        .to eq 'https://azure-na-cdn.example.com'
    end

    it 'prepends au-cdn prefix for au + custom host' do
      expect(described_class.get_contentstack_endpoint('au', 'contentDelivery', 'example.com'))
        .to eq 'https://au-cdn.example.com'
    end

    it 'falls back to cdn. prefix for an unknown region + custom host' do
      expect(described_class.get_contentstack_endpoint('unknown', 'contentDelivery', 'example.com'))
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
      expect { described_class.get_contentstack_endpoint('us', 'invalidService') }
        .to raise_error(Contentstack::Error, /Unknown service 'invalidService'/)
    end
  end

  # ---------------------------------------------------------------------------
  # Runtime fallback when regions.json is absent
  # ---------------------------------------------------------------------------
  describe '.get_contentstack_endpoint - runtime fallback' do
    it 'fetches from registry when regions.json is absent' do
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
    it 'returns the NA CDN URL for us' do
      expect(Contentstack.get_contentstack_endpoint('us')).to eq 'https://cdn.contentstack.io'
    end

    it 'returns the EU CMA URL' do
      expect(Contentstack.get_contentstack_endpoint('eu', 'contentManagement'))
        .to eq 'https://eu-api.contentstack.com'
    end

    it 'accepts Service::CDA constant' do
      expect(Contentstack.get_contentstack_endpoint('au', Contentstack::Service::CDA))
        .to eq 'https://au-cdn.contentstack.com'
    end
  end
end
