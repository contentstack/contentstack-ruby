require 'contentstack/api'
require 'contentstack/content_type'
require 'contentstack/asset_collection'

module Contentstack
  class Client
    # Initialize "Built.io Contentstack" Client instance
    def initialize(api_key, access_token, environment)
      API.init_api(api_key, access_token, environment)
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
  end
end