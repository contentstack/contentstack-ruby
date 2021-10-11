require 'uri'
require 'net/http'
require 'active_support'
require 'active_support/json'
require 'open-uri'

module Contentstack
  class API
    def self.init_api(api_key, delivery_token, environment,host, live_preview)
      @host = host
      @api_version = '/v3'
      @environment = environment
      @api_key = api_key
      @access_token = delivery_token
      @headers = {environment: @environment}
      @live_preview = live_preview
    end

    def self.live_preview_query(query= {})
      @live_preview[:content_type_uid] = query[:content_type_uid]
      @live_preview[:hash] = query[:live_preview]
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
      if  @live_preview[:enable] && @live_preview[:content_type_uid] == content_type
        path = "/content_types/#{content_type}/entries"
        send_preview_request(path, query)  
      else
        path = "/content_types/#{content_type}/entries"
        send_request(path, query)
      end
    end

    def self.fetch_entry(content_type, entry_uid, query)
      if  @live_preview[:enable] && @live_preview[:content_type_uid] == content_type
        path = "/content_types/#{content_type}/entries/#{entry_uid}"
        send_preview_request(path, query)  
      else
        path = "/content_types/#{content_type}/entries/#{entry_uid}"
        send_request(path, query)
      end
    end

    def self.get_assets(asset_uid=nil)
      path = "/assets"
      path += "/#{asset_uid}" if !asset_uid.nil?
      send_request(path)
    end

    def self.get_sync_items(query)
      path = "/stacks/sync"
      send_request(path, query)
    end

    private
    def self.send_request(path, q=nil)
      q ||= {}

      q.merge!(@headers)

      query = "?" + q.to_query
      # puts "Request URL:- #{@host}#{@api_version}#{path}#{query} \n\n"
      
      ActiveSupport::JSON.decode(open("#{@host}#{@api_version}#{path}#{query}",
      "api_key" =>  @api_key,
      "access_token"=>  @access_token,
      "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}",
      "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}").read)
    end

    def self.send_preview_request(path, q=nil)
      q ||= {}

      query = "?" + q.to_query
      preview_host = @live_preview[:host]
      
      ActiveSupport::JSON.decode(open("#{preview_host}#{@api_version}#{path}#{query}",
      "api_key" =>  @api_key,
      "authorization" => @live_preview[:management_token],
      "hash" => (!@live_preview.key?(:hash) ? 'init' : @live_preview[:hash]),
      "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}",
      "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}").read)
    end
  end
end
