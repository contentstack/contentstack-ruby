$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "contentstack/version"
require "contentstack/client"
require "util"


# == Built.io Contentstack - Ruby SDK
# Built.io Contentstack is a content management system that facilitates the process of publication by separating the content from site-related programming and design.
# == Installation
#   gem install contentstack
# == Initialize the Stack
#   @stack = Contentstack::Client.new("site_api_key", "access_token", "enviroment_name")
# == Usage
# ==== Get single entry
#   @stack.content_type('blog').entry('<entry_uid_here>').fetch
# ==== Query entries
#   @stack.content_type('blog').query.regex('title', '.*hello.*').fetch
module Contentstack
end