require "spec_helper"

describe 'Contentstack::Client' do
  let(:client) { create_client }

  describe "cannot be instantiated without required parameters" do
    it "access_token is required and cannot be a blank string" do
      expect { create_client(access_token: nil) }.to raise_error(ArgumentError, "You must specify a valid access_token")
      expect { create_client(access_token: '') }.to raise_error(ArgumentError, "You must specify a valid access_token")
    end

    it "api_key is required and cannot be a blank string" do
      expect { create_client(api_key: nil) }.to  raise_error(ArgumentError, "You must specify a valid api_key")
      expect { create_client(api_key: '') }.to raise_error(ArgumentError, "You must specify a valid api_key")
    end

    it "environment is required and cannot be a blank string" do
      expect { create_client(environment: nil) }.to  raise_error(ArgumentError, "You must specify a valid environment")
      expect { create_client(environment: '') }.to  raise_error(ArgumentError, "You must specify a valid environment" )
    end
  end

  describe 'is secure by default' do
    it 'will use https [default]' do
      expect(
        client.protocol
      ).to start_with 'https://'
    end
  end

  describe "has default configuration available on initialization" do
    subject { client.configuration }
    it { should_not be_empty }
  end

  describe "has headers set on initialization" do
    subject { client.headers }
    it { should_not be_empty }
  end

  describe "allows changing certain configuration parameters after instantiation" do

    it "allows setting a custom port" do
      expect(client.set_port(3000).port).to eq 3000
    end

    it "allows changing protocol to insecure" do
      expect(client.set_protocol(insecure: true).protocol).to eq 'http://'
    end

    xit "allows changing host" do
      expect(client.set_host("cdn.my-custom.domain").host).to eq 'cdn.my-custom.domain'
    end
  end     
end