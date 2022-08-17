require 'contentstack/api'
require 'contentstack/content_type'
require 'contentstack/asset_collection'
require 'contentstack/sync_result'
require 'util'
require 'contentstack/error'
module Contentstack
  class Client
    using Utility
    attr_reader :region, :host
    # Initialize "Contentstack" Client instance
    def initialize(api_key, delivery_token, environment, options={})
      raise Contentstack::Error.new("Api Key is not valid") if api_key.class != String
      raise Contentstack::Error.new("Api Key Field Should not be Empty") if api_key.empty?
      raise Contentstack::Error.new("Delivery Token is not valid") if delivery_token.class != String
      raise Contentstack::Error.new("Delivery Token Field Should not be Empty") if delivery_token.empty?
      raise Contentstack::Error.new("Envirnoment Field is not valid") if environment.class != String
      raise Contentstack::Error.new("Envirnoment Field Should not be Empty") if environment.empty?
      @region = options[:region].nil? ? Contentstack::Region::US : options[:region]
      @host = options[:host].nil? ? get_default_region_hosts(@region) : options[:host]
      @live_preview = !options.key?(:live_preview) ? {} : options[:live_preview]
      @branch = options[:branch].nil? ? "" : options[:branch]
      @proxy_details = options[:proxy].nil? ? "" : options[:proxy]
      @timeout = options[:timeout].nil? ? 3000 : options[:timeout]
      @retryDelay = options[:retryDelay].nil? ? 3000 : options[:retryDelay]
      @retryLimit = options[:retryLimit].nil? ? 5 : options[:retryLimit]
      @errorRetry = options[:errorRetry].nil? ? [408, 429] : options[:errorRetry]
      retry_options = {
        "timeout" =>  @timeout.to_s,
        "retryDelay"=>  @retryDelay,
        "retryLimit"=> @retryLimit,
        "errorRetry" => @errorRetry
      }
      raise Contentstack::Error.new("Proxy URL Should not be Empty") if @proxy_details.present? && @proxy_details[:url].empty?
      raise Contentstack::Error.new("Proxy Port Should not be Empty") if @proxy_details.present? && @proxy_details[:port].empty?
      API.init_api(api_key, delivery_token, environment,  @host, @branch, @live_preview, @proxy_details, retry_options)
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

    def live_preview_query(query={})
      API.live_preview_query(query)
    end
    
    # Syncs your Contentstack data with your app and ensures that the data is always up-to-date by providing delta updates
    # 
    #   Stack.sync({'init': true})        // For initializing sync
    # 
    #   Stack.sync({'init': true, 'locale': 'en-us'})     //For initializing sync with entries of a specific locale
    # 
    #   Stack.sync({'init': true, 'start_date': '2018-10-22'})    //For initializing sync with entries published after a specific date
    # 
    #   Stack.sync({'init': true, 'content_type_uid': 'session'})   //For initializing sync with entries of a specific content type
    # 
    #   Stack.sync({'init': true, 'type': 'entry_published'})   // Use the type parameter to get a specific type of content.Supports 'asset_published', 'entry_published', 'asset_unpublished', 'entry_unpublished', 'asset_deleted', 'entry_deleted', 'content_type_deleted'.
    # 
    #   Stack.sync({'pagination_token': '<pagination>'})    // For fetching the next batch of entries using pagination token
    # 
    #   Stack.sync({'sync_token': '<sync>'})    // For performing subsequent sync after initial sync
    #
    # @param params [Hash] params is an object that supports ‘locale’, ‘start_date’, ‘content_type_uid’, and ‘type’ queries.
    def sync(params)
      sync_result = API.get_sync_items(params)
      SyncResult.new(sync_result)
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