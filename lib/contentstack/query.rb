require "byebug"

module Contentstack
  class Query
    attr_reader :data

    def initialize(data, query)
      @data = data
      @query = query
    end

    def all
      data
    end

  end
end