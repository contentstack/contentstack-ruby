require 'contentstack/query'
require 'util'

module Contentstack
  class ContentType
    using Utility
    [:title, :uid, :created_at, :updated_at, :attributes].each do |method_name|
      if [:created_at, :updated_at].include?(method_name)
        define_method method_name do
          return Time.parse(@attributes[method_name]) if @attributes[method_name] && !@attributes[method_name].nil?
        end
      elsif :attributes == method_name
        define_method :attributes do
          {
            title: self.title,
            uid: self.uid,
            created_at: self.created_at,
            updated_at: self.updated_at,
            schema: @attributes[:schema]
          }
        end 
      else
        define_method method_name do
          return @attributes[method_name]
        end
      end
    end

    def initialize(object)
      @attributes = object.symbolize_keys
    end

    def query
      Query.new(self.uid)
    end

    def entry(entry_uid)
      Entry.new({uid: entry_uid}, self.uid)
    end


    def self.all
      content_types = API.fetch_content_types["content_types"]
      content_types.map do |content_type|
        ContentType.new(content_type.inject({}){|clone,(k,v)| clone[k.to_sym] = v; clone})
      end
    end

    def fetch
      content_type = API.fetch_content_types(uid)["content_type"]
      ContentType.new(content_type.inject({}){|clone,(k,v)| clone[k.to_sym] = v; clone})
    end
  end
end