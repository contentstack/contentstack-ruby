
module Contentstack

  class Response
    attr_reader :body

    def initialize(body)
      @body = body
    end

    def entries
      @body[:entries]
    end
  end

end