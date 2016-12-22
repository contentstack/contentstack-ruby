

module Contentstack
  class Entry
    
    def initialize(attributes)
      @attributes = attributes
    end

    def properties
      @attributes.keys
    end

    def is_entry?
      true
    end
  end
end