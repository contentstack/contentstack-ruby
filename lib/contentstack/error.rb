module Contentstack
  class Error < StandardError
    def initialize(msg="Something Went Wrong.")
      super
    end
  end
end