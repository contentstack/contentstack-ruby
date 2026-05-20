require 'spec_helper'

describe 'entry variants' do
  let(:client) { create_client }
  let(:branch_client) { create_client(ENV['DELIVERY_TOKEN'], ENV['API_KEY'], ENV['ENVIRONMENT'], { branch: 'stack_branch' }) }
  let(:entry_uid) { 'uid' }
  let(:category_entry) { client.content_type('category').entry(entry_uid) }
  let(:category_query) { client.content_type('category').query }

  describe Contentstack::Entry do
    it 'stores variant UID and branch on the query' do
      entry = category_entry.variants('variant1', 'branch_name')
      expect(entry.query[:variant_uids]).to eq 'variant1'
      expect(entry.query[:branch]).to eq 'branch_name'
    end

    it 'stores multiple variant UIDs' do
      entry = category_entry.variants(['variant1', 'variant2'], 'branch_name')
      expect(entry.query[:variant_uids]).to eq ['variant1', 'variant2']
    end

    it 'raises when variant UIDs are missing' do
      expect { category_entry.variants(nil) }.to raise_error(Contentstack::Error, /Variant UID/)
      expect { category_entry.variants([]) }.to raise_error(Contentstack::Error, /Variant UID/)
    end

    it 'raises when variant UIDs are invalid' do
      expect { category_entry.variants(123) }.to raise_error(Contentstack::Error, /String or Array/)
      expect { category_entry.variants(['']) }.to raise_error(Contentstack::Error, /String or Array/)
    end
  end

  describe Contentstack::Query do
    it 'stores variant UID and branch on the query' do
      query = category_query.variants('variant1', 'branch_name')
      expect(query.query[:variant_uids]).to eq 'variant1'
      expect(query.query[:branch]).to eq 'branch_name'
    end
  end

  describe 'HTTP headers' do
    it 'sends x-cs-variant-uid and branch for a single entry fetch' do
      stub = stub_request(:get, /cdn\.contentstack\.io\/v3\/content_types\/category\/entries\/uid/).
        with { |req|
          req.headers['X-Cs-Variant-Uid'] == 'variant1' &&
            req.headers['Branch'] == 'branch_name'
        }.
        to_return(status: 200, body: File.read(File.dirname(__FILE__) + '/fixtures/category_entry.json'), headers: {})

      category_entry.variants('variant1', 'branch_name').fetch
      expect(stub).to have_been_requested
    end

    it 'sends comma-separated variant UIDs for multiple variants' do
      stub = stub_request(:get, /cdn\.contentstack\.io\/v3\/content_types\/category\/entries\/uid/).
        with { |req| req.headers['X-Cs-Variant-Uid'] == 'variant1, variant2' }.
        to_return(status: 200, body: File.read(File.dirname(__FILE__) + '/fixtures/category_entry.json'), headers: {})

      category_entry.variants(['variant1', 'variant2'], 'branch_name').fetch
      expect(stub).to have_been_requested
    end

    it 'sends x-cs-variant-uid and branch for an entries query' do
      stub = stub_request(:get, /cdn\.contentstack\.io\/v3\/content_types\/category\/entries/).
        with { |req|
          !req.uri.path.include?('/entries/uid') &&
            req.headers['X-Cs-Variant-Uid'] == 'variant1' &&
            req.headers['Branch'] == 'branch_name'
        }.
        to_return(status: 200, body: File.read(File.dirname(__FILE__) + '/fixtures/category_entry_collection_without_count.json'), headers: {})

      category_query.variants('variant1', 'branch_name').fetch
      expect(stub).to have_been_requested
    end

    it 'uses stack-level branch when variants branch is omitted' do
      stub = stub_request(:get, /cdn\.contentstack\.io\/v3\/content_types\/category\/entries\/uid/).
        with { |req|
          req.headers['X-Cs-Variant-Uid'] == 'variant1' &&
            req.headers['Branch'] == 'stack_branch'
        }.
        to_return(status: 200, body: File.read(File.dirname(__FILE__) + '/fixtures/category_entry.json'), headers: {})

      branch_client.content_type('category').entry(entry_uid).variants('variant1').fetch
      expect(stub).to have_been_requested
    end

    it 'does not add variant headers when variants is not chained' do
      stub = stub_request(:get, /cdn\.contentstack\.io\/v3\/content_types\/category\/entries\/uid/).
        with { |req| req.headers['X-Cs-Variant-Uid'].nil? }.
        to_return(status: 200, body: File.read(File.dirname(__FILE__) + '/fixtures/category_entry.json'), headers: {})

      category_entry.fetch
      expect(stub).to have_been_requested
    end
  end
end
