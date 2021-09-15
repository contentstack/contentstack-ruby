require 'contentstack/asset'
require 'util'

module Contentstack
  # Asset class to fetch details of files on Conentstack server.
  class AssetCollection
    using Utility
    attr_reader :assets

    def initialize(assets_array=nil)
      if assets_array.nil?
        @assets = []
        return self
      else
        @assets = assets_array.collect{|a| Asset.new(a)}
      end
    end

    # Fetch assets uploaded to Contentstack
    #
    # Example:
    #    @assets = @stack.assets.fetch
    def fetch
      json = API.get_assets
      self.class.new(json["assets"])
    end
  end
end