require 'active_support/core_ext'

module Contentstack
  class SyncResult
    attr_reader :items
    attr_reader :sync_token
    attr_reader :pagination_token
    attr_reader :total_count
    attr_reader :skip
    attr_reader :limit

    def initialize(sync_result)
      if sync_result.nil?
        @items = []
        @sync_token = nil
        @pagination_token = nil
        @total_count = 0
        @skip = 0
        @limit = 100
      else
        @items = sync_result["items"] || []
        @sync_token = sync_result["sync_token"] || nil
        @pagination_token = sync_result["pagination_token"] || nil
        @total_count = sync_result["total_count"] || 0
        @skip = sync_result["skip"] || 0
        @limit = sync_result["limit"] || 100
      end
    end
  end
end