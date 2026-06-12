require 'json'
require 'net/http'
require 'uri'
require 'fileutils'
require 'contentstack/error'

module Contentstack
  # Centralised endpoint resolver. Reads region metadata from the local
  # regions.json (downloaded from https://artifacts.contentstack.com/regions.json
  # at gem install time) and falls back to a live fetch when the file is absent.
  #
  # Delegates to ContentstackUtils.get_contentstack_endpoint when that gem
  # ships the method (contentstack-utils-ruby PR #41).
  class Endpoint
    REGISTRY_URL   = 'https://artifacts.contentstack.com/regions.json'
    DATA_FILE_PATH = File.join(File.dirname(File.dirname(__FILE__)), 'data', 'regions.json')

    # Maps the SDK's short service keys to the camelCase keys used in regions.json,
    # preserving backward compatibility for callers using Service::CDA / Service::CMA.
    SERVICE_MAP = {
      'cda'     => 'contentDelivery',
      'cma'     => 'contentManagement',
      'preview' => 'preview'
    }.freeze

    DEFAULT_SERVICE = 'contentDelivery'

    # Resolve a Contentstack service URL for the given region and service.
    #
    #   Contentstack::Endpoint.get_contentstack_endpoint('eu')
    #   # => "https://eu-cdn.contentstack.com"
    #
    #   Contentstack::Endpoint.get_contentstack_endpoint('us', 'contentManagement')
    #   # => "https://api.contentstack.io"
    #
    #   Contentstack::Endpoint.get_contentstack_endpoint('eu', 'cda')   # short alias
    #   # => "https://eu-cdn.contentstack.com"
    #
    # When +custom_host+ is supplied the region CDN prefix is derived from
    # regions.json and prepended to the custom domain.
    def self.get_contentstack_endpoint(region, service = DEFAULT_SERVICE, custom_host = nil)
      region_key  = region.to_s.downcase
      service_key = SERVICE_MAP.fetch(service.to_s, service.to_s)

      if custom_host.nil? || custom_host.to_s.empty?
        if defined?(ContentstackUtils) && ContentstackUtils.respond_to?(:get_contentstack_endpoint)
          return ContentstackUtils.get_contentstack_endpoint(region_key, service_key)
        end
        resolve_standard(region_key, service_key)
      else
        resolve_custom_host(region_key, service_key, custom_host)
      end
    end

    # Download the latest regions.json from https://artifacts.contentstack.com/regions.json
    # and persist it locally. Called automatically by ext/download_regions/extconf.rb
    # during bundle install / bundle update, and by `bundle exec rake refresh_regions`.
    def self.refresh_regions
      data = fetch_from_registry
      FileUtils.mkdir_p(File.dirname(DATA_FILE_PATH))
      File.write(DATA_FILE_PATH, JSON.pretty_generate(data))
      data
    end

    private

    def self.resolve_standard(region_key, service_key)
      region_data = find_region(region_key)
      unless region_data
        raise Contentstack::Error.new(
          Contentstack::ErrorMessages.region_invalid(region_key, all_region_ids)
        )
      end
      unless region_data['endpoints'].key?(service_key)
        raise Contentstack::Error.new(
          Contentstack::ErrorMessages.service_invalid(service_key, region_data['endpoints'].keys)
        )
      end
      region_data['endpoints'][service_key]
    end

    def self.resolve_custom_host(region_key, service_key, custom_host)
      region_data = find_region(region_key)
      if region_data && region_data['endpoints'].key?(service_key)
        standard_url = region_data['endpoints'][service_key]
        prefix = URI.parse(standard_url).host.split('.').first
        "https://#{prefix}.#{custom_host}"
      else
        "https://cdn.#{custom_host}"
      end
    end

    # Find a region by its canonical id or any of its declared aliases.
    def self.find_region(region_key)
      load_regions['regions'].find do |r|
        r['id'] == region_key ||
          r['alias'].any? { |a| a.downcase == region_key }
      end
    end

    def self.all_region_ids
      load_regions['regions'].map { |r| r['id'] }
    end

    def self.load_regions
      if File.exist?(DATA_FILE_PATH)
        JSON.parse(File.read(DATA_FILE_PATH))
      else
        warn '[Contentstack] regions.json not found locally — fetching from registry...'
        data = fetch_from_registry
        begin
          FileUtils.mkdir_p(File.dirname(DATA_FILE_PATH))
          File.write(DATA_FILE_PATH, JSON.pretty_generate(data))
        rescue => e
          warn "[Contentstack] Could not cache regions.json: #{e.message}"
        end
        data
      end
    end

    def self.fetch_from_registry
      uri      = URI.parse(REGISTRY_URL)
      response = Net::HTTP.get_response(uri)
      unless response.is_a?(Net::HTTPSuccess)
        raise Contentstack::Error.new(
          "Failed to fetch region metadata from registry (HTTP #{response.code}). " \
          'Ensure network access and try again.'
        )
      end
      JSON.parse(response.body)
    end
  end
end
