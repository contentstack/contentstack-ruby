require 'json'
require 'net/http'
require 'uri'
require 'fileutils'
require 'contentstack/error'

module Contentstack
  # Centralised endpoint resolver. Reads region→service→URL mappings from the
  # bundled regions.json and falls back to the live registry when the file is
  # absent. Delegating to ContentstackUtils.get_contentstack_endpoint is
  # preferred when that gem exposes the method (PR #41 of contentstack-utils-ruby).
  class Endpoint
    REGISTRY_URL  = 'https://raw.githubusercontent.com/contentstack/contentstack-utils-ruby/main/lib/data/regions.json'
    DATA_FILE_PATH = File.join(File.dirname(File.dirname(__FILE__)), 'data', 'regions.json')

    DEFAULT_SERVICE = 'cda'

    # Resolve a Contentstack service URL for the given region and service.
    #
    #   Contentstack::Endpoint.get_contentstack_endpoint('eu')
    #   # => "https://eu-cdn.contentstack.com"
    #
    #   Contentstack::Endpoint.get_contentstack_endpoint('us', 'cma')
    #   # => "https://api.contentstack.io"
    #
    # When +custom_host+ is supplied the region CDN prefix is derived from
    # regions.json and prepended to the custom domain, preserving the
    # existing SDK behaviour for host-override configurations.
    def self.get_contentstack_endpoint(region, service = DEFAULT_SERVICE, custom_host = nil)
      region_key  = region.to_s.downcase
      service_key = service.to_s.downcase

      if custom_host.nil? || custom_host.to_s.empty?
        # Prefer the utils SDK when it ships endpoint resolution (PR #41)
        if defined?(ContentstackUtils) && ContentstackUtils.respond_to?(:get_contentstack_endpoint)
          return ContentstackUtils.get_contentstack_endpoint(region_key, service_key)
        end
        resolve_standard(region_key, service_key)
      else
        resolve_custom_host(region_key, service_key, custom_host)
      end
    end

    # Download and persist the latest region metadata from the registry.
    # Equivalent to `composer refresh-regions` in the PHP SDK.
    #
    #   Rake: bundle exec rake refresh_regions
    def self.refresh_regions
      data = fetch_from_registry
      FileUtils.mkdir_p(File.dirname(DATA_FILE_PATH))
      File.write(DATA_FILE_PATH, JSON.pretty_generate(data))
      data
    end

    private

    def self.resolve_standard(region_key, service_key)
      regions = load_regions
      unless regions.key?(region_key)
        raise Contentstack::Error.new(
          Contentstack::ErrorMessages.region_invalid(region_key, regions.keys)
        )
      end
      unless regions[region_key].key?(service_key)
        raise Contentstack::Error.new(
          Contentstack::ErrorMessages.service_invalid(service_key, regions[region_key].keys)
        )
      end
      regions[region_key][service_key]
    end

    # Derive the CDN subdomain prefix from regions.json and combine with the
    # caller-supplied custom domain, e.g. "eu-cdn" + "example.com" →
    # "https://eu-cdn.example.com".
    def self.resolve_custom_host(region_key, service_key, custom_host)
      regions = load_regions
      if regions.key?(region_key) && regions[region_key].key?(service_key)
        standard_url = regions[region_key][service_key]
        prefix = URI.parse(standard_url).host.split('.').first
        "https://#{prefix}.#{custom_host}"
      else
        "https://cdn.#{custom_host}"
      end
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
