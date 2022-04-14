require 'active_support/core_ext'
require 'util'

module Contentstack
  class Entry
    using Utility
    attr_reader :fields, :content_type, :uid, :owner, :query, :schema, :content_type
    def initialize(attrs, content_type_uid=nil)
      setup(attrs, content_type_uid)
    end

    # Get entries from the specified locale. 
    #
    # @param [String] code The locale code of the entry
    #
    # Example
    #    @entry = @stack.content_type('category').entry(entry_uid)
    #    @entry.locale('en-us')
    #
    # @return [Contentstack::Entry]
    def locale(code)
      @query[:locale] = code
      self
    end

    # Specifies an array of 'only' keys in BASE object that would be 'included' in the response.
    #
    # @param [Array] fields Array of the 'only' reference keys to be included in response.
    # @param [Array] fields_with_base Can be used to denote 'only' fields of the reference class
    #
    # Example
    #    # Include only title and description field in response
    #    @entry = @stack.content_type('category').entry(entry_uid)
    #    @entry.only(['title', 'description'])
    #
    #    # Query product and include only the title and description from category reference
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_reference('category')
    #          .only('category', ['title', 'description'])
    #
    # @return [Contentstack::Entry]
    def only(fields, fields_with_base=nil)
      q = {}
      if [Array, String].include?(fields_with_base.class)
        fields_with_base = [fields_with_base] if fields_with_base.class == String
        q[fields.to_sym] = fields_with_base
      else
        fields = [fields] if fields.class == String
        q = {BASE: fields}
      end

      @query[:only] = q
      self
    end

    # Specifies list of field uids that would be 'excluded' from the response.
    #
    # @param [Array] fields Array of field uid which get 'excluded' from the response.
    # @param [Array] fields_with_base Can be used to denote 'except' fields of the reference class
    #
    # Example
    #    # Exclude 'description' field in response
    #    @entry = @stack.content_type('category').entry(entry_uid)
    #    @entry.except(['description'])
    #
    #    # Query product and exclude the 'description' from category reference
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_reference('category')
    #          .except('category', ['description'])
    #
    # @return [Contentstack::Entry]
    def except(fields, fields_with_base=nil)
      q = {}
      if [Array, String].include?(fields_with_base.class)
        fields_with_base = [fields_with_base] if fields_with_base.class == String
        q[fields.to_sym] = fields_with_base
      else
        fields = [fields] if fields.class == String
        q = {BASE: fields}
      end

      @query[:except] = q
      self
    end

    # Add a constraint that requires a particular reference key details.
    #
    # @param [String/Array] reference_field_uids Pass string or array of reference fields that must be included in the response
    #
    # Example
    #
    #    # Include reference of 'category'
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_reference('category')
    #
    #    # Include reference of 'category' and 'reviews'
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_reference(['category', 'reviews'])
    #
    # @return [Contentstack::Entry]
    def include_reference(reference_field_uids)
      self.include(reference_field_uids)
    end

    # Include schemas of all returned objects along with objects themselves.
    #
    # Example
    #
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_schema
    #
    # @return [Contentstack::Entry]
    def include_schema(flag=true)
      @query[:include_schema] = flag
      self
    end

    # Include object owner's profile in the objects data.
    #
    # Example
    #
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_owner
    #
    # @return [Contentstack::Entry]
    def include_owner(flag=true)
      @query[:include_owner] = flag
      self
    end

    # Include object's content_type in response
    #
    # Example
    #
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_content_type
    #
    # @return [Contentstack::Entry]
    def include_content_type(flag=true)
      @query[:include_content_type] = flag
      self
    end

    # Include the fallback locale publish content, if specified locale content is not publish.
    #
    # Example
    #
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_fallback
    #
    # @return [Contentstack::Entry]
    def include_fallback(flag=true)
      @query[:include_fallback] = flag
      self
    end

    # Include the branch for publish content.
    #
    # Example
    #
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_branch
    #
    # @return [Contentstack::Entry]
    def include_branch(flag=true)
      @query[:include_branch] = flag
      self
    end

    # Include Embedded Objects (Entries and Assets) along with entry/entries details.
    #
    # Example
    #
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.include_embedded_items
    #
    # @return [Contentstack::Query]
    def include_embedded_items()
      @query[:include_embedded_items] = ['BASE']
      self
    end

    #
    # @return [Contentstack::Query]
    def include(field_uids)
      field_uids = [field_uids] if field_uids.class == String
      @query[:include] ||= []
      @query[:include] = @query[:include] | field_uids
      self
    end

    # Execute entry
    #
    # Example
    #
    #    @entry = @stack.content_type('product').entry(entry_uid)
    #    @entry.fetch
    #
    # @return [Contentstack::EntryCollection]
    def fetch
      entry = API.fetch_entry(@content_type, self.fields[:uid], @query)
      setup(entry["entry"])
      @schema       = entry["schema"].symbolize_keys if entry["schema"]
      @content_type = entry["content_type"].symbolize_keys if entry["content_type"]
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
      @query        = {}
    end
  end
end