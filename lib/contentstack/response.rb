require "multi_json"
require_relative 'entries'

module Contentstack

  class Response
    attr_reader :body

    def initialize(body)
      @body = begin
        MultiJson.load(body, :symbolize_keys => true)
      rescue MultiJson::ParseError => exception
        exception.data # => "{invalid json}"
        exception.cause # => JSON::ParserError: 795: unexpected token at '{invalid json}'
      end
    end

    def entries
      Entries.new(@body[:entries])
    end

    def content_types
      @body[:content_types]
    end

    def content_type
      @body[:content_type]
    end

    def entry
      @body[:entry]
    end

    def assets
      @body[:assets]
    end

    def asset
      @body[:asset]
    end

  end

end