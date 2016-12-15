
module ClientErrors

  def nil_error_for(attribute)
    "You must specify a valid #{attribute}"
  end

  def empty_error_for(attribute:)
    "#{attribute.to_s} cannot be empty"
  end
end

# class Client
#   include ClientErrors
# end

# client = Client.new
# p client.nil_error_for(:access_token)

