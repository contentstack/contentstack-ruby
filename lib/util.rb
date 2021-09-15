module Contentstack
  module Utility
    refine Hash do
      def to_query(namespace = nil)
        collect do |key, value|
          value.to_query(namespace ? "#{namespace}[#{key}]" : key)
        end.sort * '&'
      end
    
      def symbolize_keys
        new_hash = {}
        self.each do |key,value|
          if [Hash, Array].include?(value.class)
            new_hash[key.to_sym] = value.symbolize_keys
          else
            new_hash[key.to_sym] = value
          end
        end
        new_hash
      end
    end
    
    refine Array do
      def to_query(key)
        prefix = "#{key}[]"
        collect { |value| value.to_query(prefix) }.join '&'
      end
    
      def symbolize_keys
        collect do |entry|
          if entry.class == Hash
            entry.symbolize_keys
          else
            entry
          end
        end
      end
    end
    
    refine String do
      def to_query(key)
        require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
        "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
      end
      
      def to_param
        to_s
      end
    end
    
    refine Symbol do
      def to_query(key)
        to_s.to_query(key)
      end
    
      def to_param
        to_s
      end
    end
    
    refine NilClass do
      def to_query(key)
        to_s.to_query(key)
      end
    
      def to_param
        to_s
      end
    end
    
    refine TrueClass do
      def to_query(key)
        to_s.to_query(key)
      end
    
      def to_query(val)
        "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
      end
    end
    
    refine FalseClass do
      def to_query(key)
        to_s.to_query(key)
      end
    
      def to_query(val)
        "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
      end
    end
    
    refine Integer do
      def to_query(key)
        to_s.to_query(key)
      end
    
      def to_query(val)
        "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
      end
    end
    
    refine Numeric do
      def to_query(key)
        to_s.to_query(key)
      end
    
      def to_query(val)
        "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
      end
    end  
  end  
end