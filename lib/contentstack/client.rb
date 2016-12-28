require_relative 'request'
require_relative "response"
require_relative 'query'
require_relative 'utils'

require 'forwardable'
require "byebug"

module Contentstack
  class Client
    extend Forwardable

    DEFAULT_CONFIGURATION = {
      protocol: "https://",
      host: "cdn.contentstack.io",
      asset_host: "images.contentstack.io",
      port: 443,
      version: "v3",
      urls: {
        content_types: "/content_types/",
        entries: "/entries/",
        environments: "/environments/",
        assets: "/assets/"
      }
    }

    attr_reader :api_key, :access_token, :environment, :configuration, 
                :headers, :content_type, :entry_uid, :asset_uid

    # def_delegators :@query, :entries, :entry, :content_types, :content_type, :assets, :asset
    def_delegators :@configuration, :protocol, :port, :host

    # Initializes a valid client with required credentials
    #
    # @param [String] api_key
    # @param [String] access_token
    # @param [String] environment
    # @example Initializes a new client object with required credentials
    #   client = Contentstack::Client.new(access_token: ENV['ACCESS_TOKEN'], api_key: ENV['API_KEY'], environment: ENV['STACK_ENV'])

    def initialize(api_key:, access_token:, environment:)
      @api_key = api_key
      @access_token = access_token
      @environment = environment

      @configuration = Utils.to_openstruct(DEFAULT_CONFIGURATION)

      validate_configuration!
      set_headers
    end

    def set_protocol(insecure: false)
      @configuration.protocol = 'http://' if insecure
      self
    end

    def set_port(port)
      @configuration.port = port if port.is_a? Numeric
      self
    end

    def set_host(host)
      @configuration.host = host if host.is_a? String
      self
    end

    # Fetches entries from the given content_type
    #
    # @param [String] content_type
    # @param [Hash] query hash
    #
    # @return [Contentstack::Response]
    # @example
    #   entries = client.entries(content_type: 'shirts')
    def entries(content_type:, params:{})
      set_content_type(content_type.to_s)
      request = Request.new(self, endpoint(resource: :entries), params).fetch.entries
    end

    def content_types
      Request.new(self, endpoint(resource: :content_types)).fetch.content_types
    end

    def get_content_type(content_type)
      fail(ArgumentError, "content_type has to be a string") unless content_type.is_a? String
      set_content_type(content_type)
      Request.new(self, endpoint(resource: :content_type)).fetch.content_type
    end

    def set_content_type(content_type)
      @content_type = content_type
    end

    def entry(content_type:, entry_uid:)
      fail(ArgumentError, "inputs have to be string") unless content_type.is_a? String
      set_content_type(content_type)
      @entry_uid = entry_uid
      Request.new(self, endpoint(resource: :entry)).fetch.entry
    end

    def assets
      Request.new(self, endpoint(resource: :assets)).fetch.assets
    end

    def asset(asset_uid:)
      fail(ArgumentError, "content_type has to be a string") unless asset_uid.is_a? String
      @asset_uid = asset_uid
      Request.new(self, endpoint(resource: :asset)).fetch.asset
    end
    
    # Makes it easy to retrieve relevant endpoints from the configuration hash
    # @private
    def endpoint(resource:)
      case resource
      when :entries
        "#{content_url}#{content_type}#{configuration.urls.entries}"
      when :content_types
        "#{content_url}"
      when :content_type
        "#{content_url}#{content_type}"
      when :entry
        "#{content_url}#{content_type}#{configuration.urls.entries}#{entry_uid}"
      when :assets
        "#{asset_url}"
      when :asset
        "#{asset_url}#{asset_uid}"
      end

      # https://api.contentstack.io/v3/content_types/shirts/entries?environment=dev
    end

    # Returns the base url for all of the client's requests
    # @private
    def base_url
      "#{protocol}#{host}/#{configuration.version}"
    end

    # Returns the content url for all of the client's requests
    # @private
    def content_url
      "#{base_url}#{configuration.urls.content_types}"
    end

    # Returns the asset url for all of the client's requests
    # @private
    def asset_url
      "#{base_url}#{configuration.urls.assets}"
    end

    def fetch(request)
      # puts "endpoint is #{request.endpoint}"
      full_request = Typhoeus::Request.new(
        request.endpoint,
        headers: { 
          api_key: headers[:api_key], 
          access_token: headers[:access_token],
          accept_encoding: "gzip" }
      )

      response = full_request.run

      Response.new(response.body)
    end

    private

    def set_headers
      @headers = { api_key: api_key, access_token: access_token }
    end

    def validate_configuration!
      fail(ArgumentError, "You must specify a valid api_key") if api_key.nil? || api_key.empty?
      fail(ArgumentError, "You must specify a valid access_token") if access_token.nil? || access_token.empty? 
      fail(ArgumentError, "You must specify a valid environment") if environment.nil? || environment.empty?
    end

    # If the query contains the :select operator
    def normalize_select!(query)
      return unless query.key?(:select)
      query[:select] = query[:select].split(',').map(&:strip) if query[:select].is_a? String
    end
  end
end