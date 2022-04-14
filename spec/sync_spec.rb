require 'spec_helper'
require_relative '../lib/contentstack.rb'
pagination_token = "token"
describe Contentstack::SyncResult do
  let(:client) { create_client }

  it "initial sync for Stack" do
    @result = client.sync({init: true})
    expect(@result.items.length).to be 100
    expect(@result.skip).to be 0
    expect(@result.limit).to be 100
    expect(@result.total_count).to be 123
    expect(@result.pagination_token).not_to be nil
    expect(@result.sync_token).to be nil
    pagination_token = @result.pagination_token
  end

  it "next paginated sync for Stack" do
    @result = client.sync({pagination_token: pagination_token})
    expect(@result.items.length).to be 100
    expect(@result.skip).to be 0
    expect(@result.limit).to be 100
    expect(@result.total_count).to be 123
    expect(@result.pagination_token).not_to be nil
    expect(@result.sync_token).to be nil
  end
end