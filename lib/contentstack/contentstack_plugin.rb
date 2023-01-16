require 'uri'
require 'net/http'
require 'active_support'
require 'active_support/json'
require 'open-uri'
require 'util'
module Contentstack
    class ContentstackPlugin
        def self.contentstackplugin 
            onRequest(stack, http, request);
            onResponse(stack, http, request, response);
        end
    end
end
