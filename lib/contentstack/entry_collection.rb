require 'contentstack/entry'
require 'util'

module Contentstack
  class EntryCollection
    using Utility
    attr_reader :entries, :count, :content_type, :schema

    def initialize(json, content_type_uid=nil)
      @count        = json["count"] if json["count"]
      @entries      = json["entries"].collect{|entry| Entry.new(entry, content_type_uid) }
      @schema       = json["schema"].symbolize_keys if json["schema"]
      @content_type = json["content_type"].symbolize_keys if json["content_type"]
      self
    end

    def each &block
      @entries.map{|e| block.call(e)}
    end

    def map &block
      self.each(&block)
    end

    def collect &block
      self.each(&block)
    end

    def length
      @entries.length
    end

    def first
      @entries.first
    end

    def last
      @entries.last
    end

    def get(index)
      @entries[index]
    end
  end
end