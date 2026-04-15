---
name: framework
description: Use when changing Bundler setup, gemspec, gem build/release, or HTTP/retry/proxy behavior in the CDA client.
---

# Framework & packaging – Contentstack Ruby SDK

## When to use

- Editing **`Gemfile`**, **`contentstack.gemspec`**, or **`Gemfile.lock`** (via `bundle install`)
- Changing **`Contentstack::API`** request sending, timeouts, retries, or proxy support
- Preparing **`gem build`** / release alignment with **`.github/workflows/release-gem.yml`**

## Instructions

### Bundler and gemspec

- **`contentstack.gemspec`**: declares **`required_ruby_version >= 3.3`**, runtime deps **`activesupport`**, **`contentstack_utils`** (~> 1.2), and dev deps **rspec**, **webmock**, **simplecov**, **yard**.
- **`Gemfile`**: `gemspec` plus **nokogiri** pin for transitive security alignment (see comment in file)—do not remove without verifying **`contentstack_utils`** / **nokogiri** constraints.

### HTTP stack

- CDA calls are implemented in **`lib/contentstack/api.rb`** using **`Net::HTTP`**, **`URI`**, **ActiveSupport JSON**, with retry logic in **`fetch_retry`** and configurable **`timeout`**, **`retryDelay`**, **`retryLimit`**, **`errorRetry`** from **`Contentstack::Client`** options.
- **Live preview** and **proxy** paths are configured on the client and passed into **`API.init_api`**—keep option keys backward compatible.

### Release automation

- **`.github/workflows/release-gem.yml`** runs on **GitHub release created**; it uses **`ruby/setup-ruby`** (workflow currently pins Ruby **2.7** for publish—aligning that pin with **`required_ruby_version`** is an org/infrastructure concern; do not change release secrets from the skill docs).

### Local validation

- **`gem build contentstack.gemspec`** should succeed after dependency and require-path changes.
- After changing **`lib/`** load order or new files, run **`bundle exec rspec`** and smoke-require in **`irb -r contentstack`** if needed.

## References

- `skills/contentstack-ruby-sdk/SKILL.md` — client options and public API
- `skills/dev-workflow/SKILL.md` — everyday commands
- `skills/testing/SKILL.md` — stubbing HTTP for tests
- [RubyGems guides](https://guides.rubygems.org/)
