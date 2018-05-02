class Hash
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

class Array
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

class String
  def to_query(key)
    require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
    "#{CGI.escape(key.to_param)}=#{CGI.escape(to_param.to_s)}"
  end
  
  def to_param
    to_s
  end
end

class Symbol
  def to_query(key)
    to_s.to_query(key)
  end

  def to_param
    to_s
  end
end

class NilClass
  def to_query(key)
    to_s.to_query(key)
  end

  def to_param
    to_s
  end
end

class TrueClass
  def to_query(key)
    to_s.to_query(key)
  end

  def to_query(val)
    "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
  end
end

class FalseClass
  def to_query(key)
    to_s.to_query(key)
  end

  def to_query(val)
    "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
  end
end

class Integer
  def to_query(key)
    to_s.to_query(key)
  end

  def to_query(val)
    "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
  end
end

class Numeric
  def to_query(key)
    to_s.to_query(key)
  end

  def to_query(val)
    "#{CGI.escape(val.to_param)}=#{CGI.escape(to_s)}"
  end
end