require_relative 'entry'

module Contentstack
  class Entries
    include Enumerable

    attr_reader :body, :entries
      
    def initialize(body)
      @body = body
    end

    def each(&block)
      @body.each do |entry| 
        block.call(Entry.new(entry))
      end
    end
  end
end