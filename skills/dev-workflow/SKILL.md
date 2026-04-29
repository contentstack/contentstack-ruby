---
name: dev-workflow
description: Use when setting up the repo, running tests or docs, choosing branches, or aligning with release and CI expectations for contentstack-ruby.
---

# Dev workflow – Contentstack Ruby SDK

## When to use

- First-time setup or refreshing dependencies
- Running the test suite or generating YARD docs before a PR
- Choosing a base branch or understanding merge restrictions
- Bumping version or coordinating with gem release (see also `skills/framework/SKILL.md`)

## Instructions

### Environment

- Use Ruby **≥ 3.3**; match **`.ruby-version`** when using rbenv/asdf/chruby.
- From the repo root: `bundle install` (respects `Gemfile` + `contentstack.gemspec`).

### Everyday commands

- Full test suite: `bundle exec rspec`
- One file: `bundle exec rspec spec/<name>_spec.rb`
- API docs: `bundle exec rake yard` (task defined in `rakefile.rb`; options in `.yardopts`)
- Build the gem locally: `gem build contentstack.gemspec`

### Branches and PRs

- Default integration branch is typically **`development`** (confirm on GitHub). Release PRs go directly **`development` -> `master`**; `staging` is not part of the release promotion flow.
- Keep PRs focused; mention breaking API or Ruby version requirement changes in the description.

### Before you push

- Run **`bundle exec rspec`**; ensure new behavior has specs and existing stubs in `spec/spec_helper.rb` stay consistent with CDN host patterns you use.

## References

- `AGENTS.md` — stack summary and command table
- `skills/testing/SKILL.md` — RSpec and fixtures
- `skills/framework/SKILL.md` — gemspec, Bundler, HTTP concerns
- [contentstack/contentstack-ruby](https://github.com/contentstack/contentstack-ruby)
