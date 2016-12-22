
require 'typhoeus'

module Contentstack
  class Request

    attr_reader :endpoint, :client

    def initialize(client, endpoint, query={})
      # puts endpoint
      @client = client
      @endpoint = endpoint

      @query = (normalize_query(query) if query && !query.empty?)
    end

    # Delegates the actual HTTP work to the client
    def fetch
      client.fetch(self)
    end

    private

    def normalize_query(query)
      Hash[
        query.map do |key, value|
          [
            key.to_sym,
            value.is_a?(::Array) ? value.join(',') : value
          ]
        end
      ]
    end
    
  end
end