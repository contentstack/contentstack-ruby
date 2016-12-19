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
end