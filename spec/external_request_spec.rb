require 'spec_helper'

describe 'External request' do
  it 'queries FactoryGirl contributors on GitHub' do

    response = Typhoeus.get('https://api.github.com/repos/thoughtbot/factory_girl/contributors')

    expect(response).to be_an_instance_of(Typhoeus::Response)
    expect(response.body).to be_an_instance_of(String)
  end
end