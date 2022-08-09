require 'uri'
require 'net/http'
require 'active_support'
require 'active_support/json'
require 'open-uri'
require 'util'
module Contentstack
  class API
    using Utility
    def self.init_api(api_key, delivery_token, environment, host, branch, live_preview, proxy, retry_options)
      @host = host
      @api_version = '/v3'
      @environment = environment
      @api_key = api_key
      @access_token = delivery_token
      @branch = branch
      @headers = {environment: @environment}
      @live_preview = live_preview
      @proxy_details = proxy
      @timeout = retry_options["timeout"]
      @retryDelay = retry_options["retryDelay"]
      @retryLimit = retry_options["retryLimit"]
      @errorRetry = retry_options["errorRetry"]
    end

    def self.live_preview_query(query= {})
      @live_preview[:content_type_uid] = query[:content_type_uid]
      @live_preview[:live_preview] = query[:live_preview]
    end

    def self.fetch_content_types(uid="")
      if !uid.nil? && !uid.empty?
        path = "/content_types/#{uid}"
      else
        path = "/content_types"
      end
      fetch_retry(path, {})
    end

    def self.fetch_entries(content_type, query)
      if  @live_preview[:enable] && @live_preview[:content_type_uid] == content_type
        path = "/content_types/#{content_type}/entries"
        send_preview_request(path, query)  
      else
        path = "/content_types/#{content_type}/entries"
        fetch_retry(path, query)
      end
    end

    def self.fetch_entry(content_type, entry_uid, query)
      if  @live_preview[:enable] && @live_preview[:content_type_uid] == content_type
        path = "/content_types/#{content_type}/entries/#{entry_uid}"
        send_preview_request(path, query)  
      else
        path = "/content_types/#{content_type}/entries/#{entry_uid}"
        fetch_retry(path, query)
      end
    end

    def self.get_assets(asset_uid=nil)
      path = "/assets"
      path += "/#{asset_uid}" if !asset_uid.nil?
      fetch_retry(path)
    end

    def self.get_sync_items(query)
      path = "/stacks/sync"
      fetch_retry(path, query)
    end

    private
    def self.fetch_retry(path, query=nil, count=0)
      response = send_request(path, query)
      if @errorRetry.include?(response["status_code"].to_i)
        if count < @retryLimit
          retryDelay_in_seconds = @retryDelay / 1000 #converting retry_delay from milliseconds into seconds
          sleep(retryDelay_in_seconds.to_i) #sleep method requires time in seconds as parameter
          response = fetch_retry(path, query, (count + 1))
        else
         raise Contentstack::Error.new(response) #Retry Limit exceeded
        end  
      else
        response
      end
    end

    def self.send_request(path, q=nil)
      q ||= {}

      q.merge!(@headers)

      query = "?" + q.to_query
      # puts "Request URL:- #{@host}#{@api_version}#{path}#{query} \n\n"
      params = {
        "api_key" =>  @api_key,
        "access_token"=>  @access_token,
        "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}",
        "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}",
        "read_timeout" => @timeout
      }
      if !@branch.nil? && !@branch.empty?
        params["branch"] = @branch
      end

      begin
        if @proxy_details.empty?
          ActiveSupport::JSON.decode(URI.open("#{@host}#{@api_version}#{path}#{query}", params).read)
        elsif @proxy_details.present? && @proxy_details[:url].present? && @proxy_details[:port].present? && @proxy_details[:username].present? && @proxy_details[:password].present?
          proxy_uri = URI.parse("http://#{@proxy_details[:url]}:#{@proxy_details[:port]}/")
          proxy_username = @proxy_details[:username]
          proxy_password = @proxy_details[:password]
         
          if !@branch.nil? && !@branch.empty?
            ActiveSupport::JSON.decode(URI.open("#{@host}#{@api_version}#{path}#{query}", :proxy_http_basic_authentication => [proxy_uri, proxy_username, proxy_password], "api_key" =>  @api_key, "access_token"=>  @access_token, "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout, "branch" => @branch).read)
          else
            ActiveSupport::JSON.decode(URI.open("#{@host}#{@api_version}#{path}#{query}", :proxy_http_basic_authentication => [proxy_uri, proxy_username, proxy_password], "api_key" =>  @api_key, "access_token"=>  @access_token, "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout).read)
          end
        elsif @proxy_details.present? && @proxy_details[:url].present? && @proxy_details[:port].present? && @proxy_details[:username].empty? && @proxy_details[:password].empty?
          proxy_uri = URI.parse("http://#{@proxy_details[:url]}:#{@proxy_details[:port]}/")
  
          if !@branch.nil? && !@branch.empty?
            ActiveSupport::JSON.decode(URI.open("#{@host}#{@api_version}#{path}#{query}", "proxy" => proxy_uri, "api_key" =>  @api_key, "access_token"=>  @access_token, "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout, "branch" => @branch).read)
          else
            ActiveSupport::JSON.decode(URI.open("#{@host}#{@api_version}#{path}#{query}", "proxy" => proxy_uri, "api_key" =>  @api_key, "access_token"=>  @access_token, "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout).read)
          end
        end      
        rescue OpenURI::HTTPError => error
        response = error.io
        #response.status
        # => ["503", "Service Unavailable"] 
        error_response = JSON.parse(response.string)
        error_status = {"status_code" => response.status[0], "status_message" => response.status[1]}
        error = error_response.merge(error_status)
        raise Contentstack::Error.new(error.to_s)
      end
    end

    def self.send_preview_request(path, q=nil)
      q ||= {}

      q.merge!({live_preview: (!@live_preview.key?(:live_preview) ? 'init' : @live_preview[:live_preview]),})

      query = "?" + q.to_query
      preview_host = @live_preview[:host]
      params = {
        "api_key" =>  @api_key,
        "authorization" => @live_preview[:management_token],
        "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}",
        "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}",
        "read_timeout" => @timeout
      }
      if !@branch.nil? && !@branch.empty?
        params["branch"] = @branch
      end
      begin
        if @proxy_details.empty?
          ActiveSupport::JSON.decode(URI.open("#{preview_host}#{@api_version}#{path}#{query}",params).read)
        elsif @proxy_details.present? && @proxy_details[:url].present? && @proxy_details[:port].present? && @proxy_details[:username].present? && @proxy_details[:password].present?
          proxy_uri = URI.parse("http://#{@proxy_details[:url]}:#{@proxy_details[:port]}/")
          proxy_username = @proxy_details[:username]
          proxy_password = @proxy_details[:password]
  
          if !@branch.nil? && !@branch.empty?
            ActiveSupport::JSON.decode(URI.open("#{preview_host}#{@api_version}#{path}#{query}", :proxy_http_basic_authentication => [proxy_uri, proxy_username, proxy_password], "api_key" =>  @api_key, "authorization" => @live_preview[:management_token], "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout, "branch" => @branch).read)
          else
            ActiveSupport::JSON.decode(URI.open("#{preview_host}#{@api_version}#{path}#{query}", :proxy_http_basic_authentication => [proxy_uri, proxy_username, proxy_password], "api_key" =>  @api_key, "authorization" => @live_preview[:management_token], "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout).read)
          end
        elsif @proxy_details.present? && @proxy_details[:url].present? && @proxy_details[:port].present? && @proxy_details[:username].empty? && @proxy_details[:password].empty?
          proxy_uri = URI.parse("http://#{@proxy_details[:url]}:#{@proxy_details[:port]}/")
          
          if !@branch.nil? && !@branch.empty?
            ActiveSupport::JSON.decode(URI.open("#{preview_host}#{@api_version}#{path}#{query}", "proxy" => proxy_uri, "api_key" =>  @api_key, "authorization" => @live_preview[:management_token], "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout, "branch" => @branch).read)
          else
            ActiveSupport::JSON.decode(URI.open("#{preview_host}#{@api_version}#{path}#{query}", "proxy" => proxy_uri, "api_key" =>  @api_key, "authorization" => @live_preview[:management_token], "user_agent"=> "ruby-sdk/#{Contentstack::VERSION}", "x-user-agent" => "ruby-sdk/#{Contentstack::VERSION}", "read_timeout" => @timeout).read)
          end
        end
      rescue OpenURI::HTTPError => error
        response = error.io
        #response.status
        # => ["503", "Service Unavailable"] 
        error_response = JSON.parse(response.string)
        error_status = {"status_code" => response.status[0], "status_message" => response.status[1]}
        error = error_response.merge(error_status)
        raise Contentstack::Error.new(error.to_s)
      end
    end
  end
end
