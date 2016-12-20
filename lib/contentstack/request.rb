require_relative "response"

require 'typhoeus'

module Contentstack
  class Request

    attr_reader :endpoint

    def initialize(client, endpoint)
      @client = client
      @endpoint = endpoint
    end

    def fetch
      response = Typhoeus::Request.new(
        endpoint,
        headers: { 
          api_key: @client.headers[:api_key], 
          access_token: @client.headers[:access_token],
          accept_encoding: "gzip" }
      ).run

      Response.new(response.body)
    end
    
  end
end