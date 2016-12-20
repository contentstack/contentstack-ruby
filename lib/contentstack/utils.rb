require 'ostruct'
require 'json'

module Contentstack
  module Utils
    
    module_function

    # Simple way to turn a deeply nested hash into an openstruct
    # https://coderwall.com/p/74rajw/convert-a-complex-nested-hash-to-an-object
    def to_openstruct(hash)
      json = hash.to_json
      JSON.parse(json, object_class: OpenStruct)
    end

  end
end