

module Contentstack
  class Entry

    attr_reader :properties, :attributes
    
    def initialize(attributes)
      @attributes = attributes
      @properties = attributes.keys

      properties.each do |prop|
        define_singleton_method prop do
          @attributes[prop]
        end
      end
    end

    def to_s
      "#{attributes[:title]} created on #{attributes[:created_at]}"
    end

    def is_entry?
      true
    end
  end
end