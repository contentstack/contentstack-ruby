require 'typhoeus'
require "contentstack/response"
require 'multi_json'

module Contentstack

  class Client

    DEFAULT_CONFIGURATION = {
      protocol: "https://",
      host: "cdn.contentstack.io",
      port: 443,
      version: "v3",
      urls: {
        content_types: "/content_types/",
        entries: "/entries/",
        environments: "/environments/"
      }
    }

    attr_reader :api_key, :access_token, :environment, :configuration, :port, :headers

    def initialize(api_key:, access_token:, environment:)
      @api_key = api_key
      @access_token = access_token
      @environment = environment
      
      set_headers
      set_default_configuration
      validate_configuration!
    end

    def set_headers
      @headers = { api_key: api_key, access_token: access_token }
    end

    def set_default_configuration
      @configuration = DEFAULT_CONFIGURATION
    end

    def protocol
      @configuration[:protocol]
    end

    def set_protocol(insecure: false)
      @configuration[:protocol] = 'http://' if insecure
      self
    end

    def set_port(port)
      @configuration[:port] = port if port.is_a? Numeric
      self
    end

    def port
      @configuration[:port]
    end

    def host
      @configuration[:host]
    end

    def set_host(host)
      @configuration[:host] = host if host.is_a? String
      self
    end

    def validate_configuration!
      fail(ArgumentError, "You must specify a valid api_key") if api_key.nil? || api_key.empty?
      fail(ArgumentError, "You must specify a valid access_token") if access_token.nil? || access_token.empty? 
      fail(ArgumentError, "You must specify a valid environment") if environment.nil? || environment.empty?
    end

    def content_type(content_type_uid)
      @content_type = content_type_uid if content_type_uid.is_a? String
      self
    end

    def get_content_type
      @content_type
    end

    def get
      response = Typhoeus::Request.new(
        endpoint,
        headers: { api_key: headers[:api_key], access_token: headers[:access_token],
        accept_encoding: "gzip" }
      ).run

      # begin
      #   Response.new(MultiJson.load(response.body, :symbolize_keys => true))
      # rescue MultiJson::ParseError => exception
      #   exception.data # => "{invalid json}"
      #   exception.cause # => JSON::ParserError: 795: unexpected token at '{invalid json}'
      # end
    end

    
    def endpoint
      # https://api.contentstack.io/v3/content_types/shirts/entries?environment=dev
      "#{protocol}#{host}/#{configuration[:version]}#{configuration[:urls][:content_types]}#{get_content_type}#{configuration[:urls][:entries]}"
    end

  end

end