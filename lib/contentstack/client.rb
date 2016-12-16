
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

    attr_reader :access_key, :access_token, :environment, :configuration, :port, :headers

    def initialize(access_key:, access_token:, environment:)
      @access_key = access_key
      @access_token = access_token
      @environment = environment
      
      set_headers
      set_default_configuration
      validate_configuration!
    end

    def set_headers
      @headers = { access_key: access_key, access_token: access_token }
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
      fail(ArgumentError, "You must specify a valid access_key") if access_key.nil? || access_key.empty?
      fail(ArgumentError, "You must specify a valid access_token") if access_token.nil? || access_token.empty? 
      fail(ArgumentError, "You must specify a valid environment") if environment.nil? || environment.empty?
    end
  end

end