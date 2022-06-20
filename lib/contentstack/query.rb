require 'contentstack/entry_collection'
require 'util'

module Contentstack
  # A class that defines a query that is used to query for Entry instance.
  class Query
    using Utility
    # @!attribute [r] query
    #   Attribute which has all the information about the query which will be executed against Contentstack API

    # @!attribute [r] content_type
    #   Denotes which `content_type` should the query be executed for

    attr_reader :query, :content_type

    # Initialize the Query instance
    # @param [String] content_type
    #
    # Example:
    #    @query   = @stack.content_type('blog').query
    #    @entries = @query.where('author', 'John Doe').fetch
    #
    # @return [Contentstack::Query]
    def initialize(content_type)
      @content_type = content_type
      @query = {
        query: "{}",
        include_count: false,
        skip: 0,
        count: 10,
        desc: 'created_at'
      }
    end

    # Add a custom query against specified key.
    # @param [String] field_uid
    # @param [String/Number/Boolean/Hash] value
    #
    # Example:
    #    @query   = @stack.content_type('blog').query
    #    @query.add_query('author', "Jane Doe")
    #
    # @return [Contentstack::Query]
    def add_query(field_uid, value)
      add_query_hash({:"#{field_uid}" => value})
    end

    # Remove provided query key from custom query if exist.
    # @param [String] field_uid
    #
    # Example:
    #    @query   = @stack.content_type('blog').query
    #    @query.remove_query('author')
    #
    # @return [Contentstack::Query]
    def remove_query(field_uid)
      q = ActiveSupport::JSON.decode(@query[:query])
      q.delete(field_uid)
      @query[:query] = ActiveSupport::JSON.encode(q)
      self
    end

    # Add a constraint to fetch all entries that contains given value against specified key.
    # @param [Hash] query_hash
    #
    # Example:
    #    @query = @stack.content_type('blog').query
    #    @query.where({:author => "Jane Doe"})
    #
    # @return [Contentstack::Query]
    def where(query_hash)
      add_query_hash(query_hash)
    end

    # Add a regular expression constraint for finding string values that match the provided regular expression. This may be slow for large data sets.
    # @param [String] field_uid  The key to be constrained.
    # @param [String] pattern  The regular expression pattern to match.
    # @param [String] options  Regex options
    #
    # Example:
    #    @query = @stack.content_type('product').query
    #    @query.regex('title', '.*Mobile.*', 'i') # Search without case sensitivity
    #
    # @return [Contentstack::Query]
    def regex(field_uid, pattern, options="")
      hash = {
        "#{field_uid}" => {
          "$regex": pattern
        }
      }

      hash["#{field_uid}"]["$options"] = options if !options.empty? || !options.nil?

      add_query_hash(hash)
    end

    # Add a constraint that requires, a specified key exists in response.
    # @param [String] field_uid The key to be constrained.
    #
    # Example:
    #    @query = @stack.content_type('product').query
    #    @query.exists?('product_image') # only fetch products which have a `product_image`
    #
    # @return [Contentstack::Query]
    def exists?(field_uid)
      add_query_hash({:"#{field_uid}" => {"$exists" => true}})
    end

    # Add a constraint that requires, a specified key does not exists in response.
    # @param [String] field_uid The key to be constrained.
    #
    # Example:
    #    @query = @stack.content_type('product').query
    #    @query.not_exists?('product_image') # only fetch products which do not have a `product_image`
    #
    # @return [Contentstack::Query]
    def not_exists?(field_uid)
      add_query_hash({:"#{field_uid}" => {"$exists" => false}})
      self
    end

    # Combines all the queries together using AND operator.
    #
    # @param [Array] queries  Array of instances of the Query class
    #
    # Each query should be an instance of the Contentstack::Query class, and belong to the same `content_type`
    # Example:
    #    @query1 = @stack.content_type('category').query
    #    @query1.where('title', 'Electronics')
    # 
    #    @query2 = @stack.content_type('category').query
    #    @query2.regex('description', '.*Electronics.*')
    #
    #    query_array = [@query1, @query2]
    #
    #    @query = @stack.content_type('category').query
    #    @query.and(query_array)
    #
    # @return [Contentstack::Query]
    def and(queries)
      add_query_hash({"$and" => concat_queries(queries)})
      self
    end

    # Combines all the queries together using OR operator.
    #
    # @param [Array] queries  Array of instances of the Query class
    #
    # Each query should be an instance of the Contentstack::Query class, and belong to the same `content_type`
    # Example:
    #    @query1 = @stack.content_type('category').query
    #    @query1.where('title', 'Electronics')
    # 
    #    @query2 = @stack.content_type('category').query
    #    @query2.where('title', 'Apparel')
    #
    #    query_array = [@query1, @query2]
    #
    #    @query = @stack.content_type('category').query
    #    @query.or(query_array)
    #
    # @return [Contentstack::Query]
    def or(queries)
      add_query_hash({"$or" => concat_queries(queries)})
      self
    end

    # Add a constraint to the query that requires a particular key entry to be less than the provided value.
    #
    # @param [String] field_uid  UID of the field for which query should be executed
    # 
    # @param [String/Number] value  Value that provides an upper bound
    # 
    # Example
    #    @query = @stack.content_type('product').query
    #    @query.less_than('price', '100')
    #
    # @return [Contentstack::Query]
    def less_than(field_uid, value)
      add_query_hash({:"#{field_uid}" => {"$lt" => value}})
      self
    end

    # Add a constraint to the query that requires a particular key entry to be less than or equal to the provided value.
    #
    # @param [String] field_uid  UID of the field for which query should be executed
    # 
    # @param [String/Number] value  Value that provides an upper bound
    # 
    # Example
    #    @query = @stack.content_type('product').query
    #    @query.less_than_or_equal('price', '100')
    #
    # @return [Contentstack::Query]
    def less_than_or_equal(field_uid, value)
      add_query_hash({:"#{field_uid}" => {"$lte" => value}})
      self
    end

    # Add a constraint to the query that requires a particular key entry to be greater than the provided value.
    #
    # @param [String] field_uid  UID of the field for which query should be executed
    # 
    # @param [String/Number] value  Value that provides a lower bound
    # 
    # Example
    #    @query = @stack.content_type('product').query
    #    @query.greater_than('price', '100')
    #
    # @return [Contentstack::Query]
    def greater_than(field_uid, value)
      add_query_hash({:"#{field_uid}" => {"$gt" => value}})
      self
    end

    # Add a constraint to the query that requires a particular key entry to be greater than or equal to the provided value.
    #
    # @param [String] field_uid UID of the field for which query should be executed
    # 
    # @param [String/Number] value Value that provides a lower bound
    # 
    # Example
    #    @query = @stack.content_type('product').query
    #    @query.greater_than_or_equal('price', '100')
    #
    # @return [Contentstack::Query]
    def greater_than_or_equal(field_uid, value)
      add_query_hash({:"#{field_uid}" => {"$gte" => value}})
      self
    end

    # Add a constraint to the query that requires a particular key's entry to be not equal to the provided value.
    #
    # @param [String] field_uid UID of the field for which query should be executed
    # @param [String] value The object that must not be equaled.
    #
    # Example
    #    @query = @stack.content_type('product').query
    #    @query.not_equal_to('price', '100')
    #
    # @return [Contentstack::Query]
    def not_equal_to(field_uid, value)
      add_query_hash({:"#{field_uid}" => {"$ne" => value}})
      self
    end

    # Add a constraint to the query that requires a particular key's entry to be contained in the provided array.
    #
    # @param [String] field_uid UID of the field for which query should be executed
    # @param [String] values The possible values for the key's object
    #
    # Example 1 - Array Equals Operator Within Group
    #    @query = @stack.content_type('category').query
    #    @query.contained_in("title", ["Electronics", "Apparel"])
    #
    # Example 2 - Array Equals Operator Within Modular Blocks
    #    @query = @stack.content_type('category').query
    #    @query.contained_in("additional_info.deals.deal_name", ["Christmas Deal", "Summer Deal"])
    #
    # @return [Contentstack::Query]
    def contained_in(field_uid, values)
      add_query_hash({:"#{field_uid}" => {"$in" => values}})
      self
    end

    # Add a constraint to the query that requires a particular key entry's value not be contained in the provided array.
    #
    # @param [String] field_uid UID of the field for which query should be executed
    # @param [String] values The possible values for the key's object
    #
    # Example 1 - Array Not-equals Operator Within Group
    #    @query = @stack.content_type('category').query
    #    @query.not_contained_in("title", ["Electronics", "Apparel"])
    #
    # Example 2 - Array Not-equals Operator Within Modular Blocks
    #    @query = @stack.content_type('category').query
    #    @query.not_contained_in("additional_info.deals.deal_name", ["Christmas Deal", "Summer Deal"])
    #
    # @return [Contentstack::Query]
    def not_contained_in(field_uid, values)
      add_query_hash({:"#{field_uid}" => {"$nin" => values}})
      self
    end

    # The number of objects to skip before returning any.
    #
    # @param [Number] count of objects to skip from resulset.
    #
    # Example
    #    @query = @stack.content_type('category').query
    #    @query.skip(50)
    #
    # @return [Contentstack::Query]
    def skip(count)
      @query[:skip] = count
      self
    end

    # This method provides only the entries matching the specified value.
    # @deprecated since version 0.5.0
    # @param [String] text value used to match or compare
    #
    # Example
    #    @query = @stack.content_type('product').query
    #    @query.search("This is an awesome product")
    #
    # @return [Contentstack::Query]
    def search(text)
      @query[:typeahead] = text
      self
    end

    # A limit on the number of objects to return.
    #
    # @param [Number] count of objects to limit in resulset.
    #
    # Example
    #    @query = @stack.content_type('category').query
    #    @query.limit(50)
    #
    # @return [Contentstack::Query]
    def limit(count=10)
      @query[:limit] = count
      self
    end

    # Retrieve only count of entries in result.
    #
    # Example
    #    @query = @stack.content_type('category').query
    #    @query.count
    #
    # @return [Integer]
    def count
      include_count
      fetch.count
    end

    # Retrieve count and data of objects in result.
    #
    # Example
    #    @query = @stack.content_type('category').query
    #    @query.include_count
    #
    # @return [Contentstack::Query]
    def include_count(flag=true)
      @query[:include_count] = flag
      self
    end

    # Sort the results in ascending order with the given key. 
    # Sort the returned entries in ascending order of the provided key.
    #
    # @param [String] field_uid The key to order by
    #
    # Example
    #    @query = @stack.content_type('category').query
    #    @query.ascending
    #
    # @return [Contentstack::Query]
    def ascending(field_uid)
      @query.delete(:desc)
      @query[:asc] = field_uid
      self
    end

    # Sort the results in descending order with the given key. 
    # Sort the returned entries in descending order of the provided key.
    #
    # @param [String] field_uid The key to order by
    #
    # Example
    #    @query = @stack.content_type('category').query
    #    @query.descending
    #
    # @return [Contentstack::Query]
    def descending(field_uid)
      @query.delete(:asc)
      @query[:desc] = field_uid
      self
    end

    # Get entries from the specified locale. 
    #
    # @param [String] code The locale code of the entry
    #
    # Example
    #    Change language method
    #    @query = @stack.content_type('category').query
    #    @query.locale('en-us')
    #
    # @return [Contentstack::Query]
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
    #    @query = @stack.content_type('category').query
    #    @query.only(['title', 'description'])
    #
    #    # Query product and include only the title and description from category reference
    #    @query = @stack.content_type('product').query
    #    @query.include_reference('category')
    #          .only('category', ['title', 'description'])
    #
    # @return [Contentstack::Query]
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
    #    @query = @stack.content_type('category').query
    #    @query.except(['description'])
    #
    #    # Query product and exclude the 'description' from category reference
    #    @query = @stack.content_type('product').query
    #    @query.include_reference('category')
    #          .except('category', ['description'])
    #
    # @return [Contentstack::Query]
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
    #    @query = @stack.content_type('product').query
    #    @query.include_reference('category')
    #
    #    # Include reference of 'category' and 'reviews'
    #    @query = @stack.content_type('product').query
    #    @query.include_reference(['category', 'reviews'])
    #
    # @return [Contentstack::Query]
    def include_reference(reference_field_uids)
      self.include(reference_field_uids)
    end

    # Include schemas of all returned objects along with objects themselves.
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.include_schema
    #
    # @return [Contentstack::Query]
    def include_schema(flag=true)
      @query[:include_schema] = flag
      self
    end

    # Include object owner's profile in the objects data.
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.include_owner
    #
    # @return [Contentstack::Query]
    def include_owner(flag=true)
      @query[:include_owner] = flag
      self
    end

    # Include object's content_type in response
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.include_content_type
    #
    # @return [Contentstack::Query]
    def include_content_type(flag=true)
      @query[:include_content_type] = flag
      self
    end


    # Include the fallback locale publish content, if specified locale content is not publish.
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.include_fallback
    #
    # @return [Contentstack::Query]
    def include_fallback(flag=true)
      @query[:include_fallback] = flag
      self
    end

    # Include the branch for publish content.
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.include_branch
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
    #    @query = @stack.content_type('product').query
    #    @query.include_embedded_items
    #
    # @return [Contentstack::Query]
    def include_embedded_items()
      @query[:include_embedded_items] = ['BASE']
      self
    end

    # Include objects in 'Draft' mode in response
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.include_draft
    #
    # @return [Contentstack::Query]
    def include_draft(flag=true)
      @query[:include_draft] = flag
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

    # Include tags with which to search entries.
    #
    # @param [Array] tags_array Array of tags using which search must be performed
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.tags(["tag1", "tag2"])
    #
    # @return [Contentstack::Query]
    def tags(tags_array)
      @query[:tags] = tags_array
      self
    end


    # Execute query
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.tags(["tag1", "tag2"])
    #          .fetch
    #
    # @return [Contentstack::EntryCollection]
    def fetch
      entries = API.fetch_entries(@content_type, @query)
      EntryCollection.new(entries, @content_type)
    end

    # Execute a Query and get the single matching object
    #
    # Example
    #
    #    @query = @stack.content_type('product').query
    #    @query.tags(["tag1", "tag2"])
    #          .find_one
    #
    # @return [Contentstack::Entry]
    def find_one
      limit 1
      fetch.first
    end

    alias_method :find, :fetch
    alias_method :in, :contained_in
    alias_method :not_in, :not_contained_in

    private
    def add_query_hash(query_hash)
      q = ActiveSupport::JSON.decode(@query[:query])
      q.merge!(query_hash)
      @query[:query] = ActiveSupport::JSON.encode(q)
      self
    end

    def concat_queries(queries)
      this_queries = []
      this_query = ActiveSupport::JSON.decode(@query[:query])
      if this_query.keys.length > 0
        this_queries = [this_query]
      end

      if queries.class == Array
        queries.map do |query_object|
          if query_object.class == Contentstack::Query && query_object.content_type == @content_type
            q = ActiveSupport::JSON.decode(query_object.query[:query])
            this_queries.push(q.symbolize_keys)
          end
        end
      end

      this_queries
    end
  end
end