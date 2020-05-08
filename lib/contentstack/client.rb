require 'contentstack/api'
require 'contentstack/content_type'
require 'contentstack/asset_collection'

module Contentstack
  class Client
    attr_reader :region, :host
    # Initialize "Contentstack" Client instance
    def initialize(api_key, delivery_token, environment, options={})
      @region = options[:region].nil? ? Contentstack::Region::US : options[:region]
      @host = options[:host].nil? ? get_default_region_hosts(@region) : options[:host]
      API.init_api(api_key, delivery_token, environment,  @host)
    end

    
    def content_types
      ContentType.all
    end

    def content_type(uid)
      ContentType.new({uid: uid})
    end

    def assets
      AssetCollection.new
    end

    def asset(uid)
      Asset.new(uid)
    end

    private
    def get_default_region_hosts(region='us')
      case region
      when "us"
        host = "https://cdn.contentstack.io"
      when "eu"
        host = "https://eu-cdn.contentstack.com"
      end
      host
    end
  end
end