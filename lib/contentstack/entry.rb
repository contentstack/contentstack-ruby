require 'active_support/core_ext'

module Contentstack
  class Entry
    attr_reader :fields, :content_type, :uid, :owner
    def initialize(attrs, content_type_uid=nil)
      setup(attrs, content_type_uid)
    end

    def fetch
      entry = API.fetch_entry(@content_type, self.fields[:uid])
      setup(entry["entry"])
      self
    end

    def get(field_uid)
      raise Contentstack::Error("Please send a valid Field UID") if field_uid.class != String
      @fields[field_uid.to_sym]
    end

    private
    def setup(attrs, content_type_uid=nil)
      @fields       = attrs.symbolize_keys
      @content_type = content_type_uid if !content_type_uid.blank?
      @owner        = attrs[:_owner] if attrs[:_owner]
      @uid          = attrs[:uid]
    end
  end
end