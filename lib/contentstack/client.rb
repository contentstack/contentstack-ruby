
module Contentstack

  class Client
    attr_reader :access_key, :access_token, :environment

    def initialize(access_key:, access_token:, environment:)
      @access_key = access_key
      @access_token = access_token
      @environment = environment

      validate_configuration!
    end

    def validate_configuration!
      fail(ArgumentError, "You must specify a valid access_key") if access_key.nil? || access_key.empty?
      fail(ArgumentError, "You must specify a valid access_token") if access_token.nil? || access_token.empty? 
      fail(ArgumentError, "You must specify a valid environment") if environment.nil? || environment.empty?
    end
  end

end