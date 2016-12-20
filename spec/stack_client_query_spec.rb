require "spec_helper"

describe Contentstack::Client do
  let(:client) { create_client }
  let(:content_type_uid) { "shirts" }

  describe "can query for entries by asking for a content_type" do
    it "returns a Typhoeus response with queried with a content_type" do
      response = client.content_type(content_type_uid).get
      expect(response).to be_instance_of(Typhoeus::Response)
    end
  end

  describe '#get' do
    use_vcr_cassette

    # let(:client) { create_client }

    # let(:request) do
    #   Contentstack::Request.new(nil, '/content_types', nil, 'shirts')
    # end

    def make_http_request
      Typhoeus.get('https://api.github.com/repos/thoughtbot/factory_girl/contributors')
    end

    it 'records an http request', :focus=>true do
      expect(make_http_request).to eq 'Hello'
    end

    # it 'uses #endpoint', :vcr do
    #   allow(client).to receive(:endpoint).and_return('https://cdn.contentstack.io/content_types/shirts/entries')
    #   vcr('entries') { client.get(request) }
    #   expect(client).to have_received.endpoint
    # end
  end
end