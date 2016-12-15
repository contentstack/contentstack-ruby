require "spec_helper"

describe 'Contentstack::Client Configuration' do
  describe ":access_token" do
    it "is required and cannot be a blank string" do
      expect { create_client(access_token: nil) }.to raise_error(ArgumentError, "You must specify a valid access_token")
      expect { create_client(access_token: '') }.to raise_error(ArgumentError, "You must specify a valid access_token")
    end
  end

  describe ":access_key" do
    it "is required and cannot be a blank string" do
      expect { create_client(access_key: nil) }.to  raise_error(ArgumentError, "You must specify a valid access_key")
      expect { create_client(access_key: '') }.to raise_error(ArgumentError, "You must specify a valid access_key")
    end
  end

  describe ":environment" do
    it "is required and cannot be a blank string" do
      expect { create_client(environment: nil) }.to  raise_error(ArgumentError, "You must specify a valid environment")
      expect { create_client(environment: '') }.to  raise_error(ArgumentError, "You must specify a valid environment" )
    end
  end
end