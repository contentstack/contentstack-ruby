require 'uri'
require 'net/http'
require 'active_support'
require 'active_support/json'
require 'open-uri'

module Contentstack
  class API
    def self.init_api(api_key, access_token, environment)
      @host = "https://cdn.contentstack.io"
      @api_version = '/v3'
      @environment = environment
      @headers = {api_key: api_key, access_token: access_token, user_agent: "ruby-sdk/#{Contentstack::VERSION}", environment: @environment}
    end

    def self.fetch_content_types(uid="")
      if !uid.nil? && !uid.empty?
        path = "/content_types/#{uid}"
      else
        path = "/content_types"
      end
      send_request(path, {})
    end

    def self.fetch_entries(content_type, query)
      path = "/content_types/#{content_type}/entries"
      send_request(path, query)
    end

    def self.fetch_entry(content_type, entry_uid)
      path = "/content_types/#{content_type}/entries/#{entry_uid}"
      send_request(path)
    end

    def self.get_assets(asset_uid=nil)
      path = "/assets"
      path += "/#{asset_uid}" if !asset_uid.nil?
      send_request(path)
    end

    private
    def self.send_request(path, q=nil)
      q ||= {}

      q.merge!(@headers)
      q.merge!({timestamp: Time.now.to_i})

      query = "?" + q.to_query
      # puts "Request URL:- #{@host}#{@api_version}#{path}#{query} \n\n"
      
      ActiveSupport::JSON.decode(open("#{@host}#{@api_version}#{path}#{query}").read)
    end
  end
end