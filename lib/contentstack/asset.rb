require 'util'
module Contentstack

  # Asset class to fetch file details on Conentstack server.
  class Asset
    using Utility
    attr_reader :uid, :content_type, :filename, :file_size, :tags, :url

    # @!attribute [r] uid
    #   Contentstack Asset UID for this asset

    # @!attribute [r] content_type
    #   Content Type for the asset. image/png, image/jpeg, application/pdf, video/mp4 etc.

    # @!attribute [r] filename
    #   Name of the asset.

    # @!attribute [r] file_size
    #   Size of the asset.

    # @!attribute [r] tags
    #   Array of tags assigned to the asset.

    # @!attribute [r] url
    #   URL to fetch/render the asset

    # Create instance of an Asset. Accepts either a uid of asset (String) or a complete asset JSON
    # @param [String/Hash] attrs
    # Usage for String parameter
    #   @asset = @stack.asset("some_asset_uid")
    #   @asset.fetch
    #
    # Usage for Hash parameter
    #   @asset = @stack.asset({
    #     :uid          => "some_asset_uid",
    #     :content_type => "file_type", # image/png, image/jpeg, application/pdf, video/mp4 etc.
    #     :filename    => "some_file_name",
    #     :file_size    => "some_file_size",
    #     :tags         => ["tag1", "tag2", "tag3"],
    #     :url          => "file_url"
    #   })
    #   @asset.fetch
    def initialize(attrs)
      if attrs.class == String
        @uid = attrs
      else
        attrs = attrs.symbolize_keys
        @uid = attrs[:uid]
        @content_type = attrs[:content_type]
        @filename = attrs[:filename]
        @file_size = attrs[:file_size]
        @tags = attrs[:tags]
        @url = attrs[:url]
      end

      self
    end

    # Fetch a particular asset using uid.
    #   @asset = @stack.asset('some_asset_uid')
    #   @asset.fetch
    #   puts @asset.url
    def fetch
      json = API.get_assets(@uid)
      # puts "json -- #{json}"
      self.class.new(json["asset"])
    end
  end
end