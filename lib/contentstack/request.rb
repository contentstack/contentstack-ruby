require "byebug"
require "json"
require 'typhoeus'
require "uri"
require "active_support/core_ext/hash"

module Contentstack
  class Request

    attr_reader :client
    attr_accessor :endpoint, :params, :query

    def initialize(client, endpoint, params={}, query={})
      @client = client
      @params = params
      @query = query
      @endpoint = build_endpoint(endpoint)
    end

    # Delegates the actual HTTP work to the client
    def fetch
      client.fetch(self)
    end

    def build_endpoint(initial_endpoint)
      return initial_endpoint if no_params_or_query
      return initial_endpoint += '?' + build_query(query) if query_but_no_params
      return initial_endpoint += '?' + build_params(params) if params_but_no_query
      # go ahead and build endpoint with both params and query
      initial_endpoint += '?' + build_params(params) + '&' + build_query(query)
    end

    private

    def no_params_or_query
      params.empty? && query.empty?
    end

    def query_but_no_params
      !! query && params.empty?
    end

    def params_but_no_query
      !! params && query.empty?
    end

    def build_query(query)
      encoded = URI.encode(query.to_json)
      "query=#{encoded}"
    end

    def build_params(params)
      limit      = Hash[limit:      params[:limit]   ||  0]
      skip       = Hash[skip:       params[:skip]    ||  0]
      asc        = Hash[asc:        params[:asc]     || ""]
      desc       = Hash[desc:       params[:desc]    || ""]

      query = [limit, skip, asc, desc].select { |hash| hash.values.none? { |val| val == '' || val == 0 } }
      encoded = query.map{ |q| q.to_query }.join("&")

      references = build_references(params[:include]) || ""

      query_string = references.empty? ? "#{encoded}" : "#{references}&#{encoded}"
    end

    def build_references(references)
      [references].join(",").split(",").map{ |ref| "include[]=#{ref}" }.join("&").gsub(/\s+/, "")
    end

  end
end