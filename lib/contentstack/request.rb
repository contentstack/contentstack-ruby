require "byebug"
require 'typhoeus'
require "active_support/core_ext/hash"

module Contentstack
  class Request

    attr_reader :client, :query, :endpoint_with_params
    attr_accessor :endpoint, :params

    def initialize(client, endpoint, params={})
      # puts endpoint
      @client = client
      @endpoint = endpoint
      @endpoint = build_query(params, endpoint + "?") unless params.empty?
    end

    # Delegates the actual HTTP work to the client
    def fetch
      client.fetch(self)
    end

    private

    def build_query(params, endpoint)
      limit      = Hash[limit:      params[:limit]   ||  0]
      skip       = Hash[skip:       params[:skip]    ||  0]
      asc        = Hash[asc:        params[:asc]     || ""]
      desc       = Hash[desc:       params[:desc]    || ""]

      query = [limit, skip, asc, desc].select { |hash| hash.values.none? { |val| val == '' || val == 0 } }
      encoded = query.map{ |q| q.to_query }.join("&")

      references = build_references(params[:include]) || ""

      query_string = references.empty? ? "#{endpoint}#{encoded}" : "#{endpoint}#{references}&#{encoded}"
    end

    def build_references(references)
      [references].join(",").split(",").map{ |ref| "include[]=#{ref}" }.join("&").gsub(/\s+/, "")
    end


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