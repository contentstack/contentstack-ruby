$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "contentstack/version"
require "contentstack/client"
require "contentstack/region"
require "contentstack_utils"

# == Contentstack - Ruby SDK
# Contentstack is a content management system that facilitates the process of publication by separating the content from site-related programming and design.
# == Installation
#   gem install contentstack
# == Initialize the Stack
#   @stack = Contentstack::Client.new("site_api_key", "delivery_token", "enviroment_name")
# == Initialize the Stack for EU region
#   @stack = Contentstack::Client.new("site_api_key", "delivery_token", "enviroment_name", {"region": Contentstack::Region::EU })
# == Initialize the Stack for custom host
#   @stack = Contentstack::Client.new("site_api_key", "delivery_token", "enviroment_name", {"host": "https://custom-cdn.contentstack.com" })
# == Initialize the Stack for EU region
#   @stack = Contentstack::Client.new("site_api_key", "delivery_token", "enviroment_name", {"branch":"branch_name" })
# == Usage
# ==== Get single entry
#   @stack.content_type('blog').entry('<entry_uid_here>').fetch
# ==== Query entries
#   @stack.content_type('blog').query.regex('title', '.*hello.*').fetch
module Contentstack
    def self.render_content(content, options)
        ContentstackUtils.render_content(content, options)
    end
    def self.json_to_html(content, options)
        ContentstackUtils.json_to_html(content, options)
    end
end