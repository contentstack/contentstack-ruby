---
name: testing
description: Use when writing or fixing RSpec examples, WebMock stubs, JSON fixtures, SimpleCov, or env-based test helpers.
---

# Testing – Contentstack Ruby SDK

## When to use

- Adding specs under **`spec/`**
- Changing CDN hosts, paths, or headers used in **`Contentstack::API`**
- Updating global **`WebMock`** stubs in **`spec/spec_helper.rb`**
- Interpreting **SimpleCov** output under **`coverage/`**

## Instructions

### Runner and config

- Run **`bundle exec rspec`** from the repo root.
- **`spec/spec_helper.rb`** requires **WebMock/RSpec**, disables real network (`WebMock.disable_net_connect!(allow_localhost: true)`), starts **SimpleCov**, and requires **`contentstack`**.

### Stubbing HTTP

- Default stubs live in **`config.before(:each)`** in **`spec/spec_helper.rb`** for hosts such as **`cdn.contentstack.io`**, **`eu-cdn.contentstack.com`**, **`custom-cdn.contentstack.com`**, and **`preview.contentstack.io`**.
- When adding endpoints or hosts, add matching **`stub_request`** entries and JSON fixtures under **`spec/fixtures/`** (reuse shape of real CDA responses where possible).

### Fixtures

- Store static JSON under **`spec/fixtures/*.json`**; load with **`File.read`** relative to **`__dir__`** or **`File.dirname(__FILE__)`** as existing specs do.

### Helpers

- **`create_client`** and **`create_preview_client`** in **`spec_helper`** build clients using **`ENV['API_KEY']`**, **`ENV['DELIVERY_TOKEN']`**, **`ENV['ENVIRONMENT']`** — tests should not rely on real credentials; stubs supply responses.

### Coverage

- **SimpleCov** runs on every **`rspec`** invocation; review **`coverage/index.html`** after substantive **`lib/`** changes.

## References

- `skills/contentstack-ruby-sdk/SKILL.md` — which classes own behavior under test
- `skills/dev-workflow/SKILL.md` — commands
- [RSpec](https://rspec.info/), [WebMock](https://github.com/bblimke/webmock)
