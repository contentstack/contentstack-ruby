require_relative 'entry'

module Contentstack
  class Entries
    include Enumerable

    attr_reader :body, :entries
      
    def initialize(body)
      @body = body
      @entries = body.map { |entry| Entry.new(entry) }
    end

    def each(&block)
      entries.each(&block)
    end
  end
end