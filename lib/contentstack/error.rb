module Contentstack
  # Centralized error messages for the SDK
  module ErrorMessages
    API_KEY_INVALID = "API Key is invalid. Provide a valid API Key and try again."
    API_KEY_REQUIRED = "API Key is required. Provide a valid API Key and try again."
    DELIVERY_TOKEN_INVALID = "Delivery Token is invalid. Provide a valid Delivery Token and try again."
    DELIVERY_TOKEN_REQUIRED = "Delivery Token is required. Provide a valid Delivery Token and try again."
    ENVIRONMENT_INVALID = "Environment is invalid. Provide a valid Environment and try again."
    ENVIRONMENT_REQUIRED = "Environment is required. Provide a valid Environment and try again."
    PROXY_URL_REQUIRED = "Proxy URL is required. Provide a valid Proxy URL and try again."
    PROXY_PORT_REQUIRED = "Proxy Port is required. Provide a valid Proxy Port and try again."

    def self.request_failed(response)
      "The request could not be completed due to #{response}. Review the details and try again."
    end

    def self.request_error(error)
      "The request encountered an issue due to #{error}. Review the details and try again."
    end
  end

  class Error < StandardError
    def initialize(msg="Something Went Wrong.")
      super
    end
  end
end