# Contentstack Ruby SDK – Agent guide

**Universal entry point** for contributors and AI agents. Detailed conventions live in **`skills/*/SKILL.md`**.

## What this repo is

| Field | Detail |
| --- | --- |
| **Name:** | [contentstack/contentstack-ruby](https://github.com/contentstack/contentstack-ruby) (Ruby gem `contentstack`) |
| **Purpose:** | Ruby client for the Contentstack Content Delivery API (CDA): stack client, content types, entries, assets, queries, sync, and live preview. |
| **Out of scope (if any):** | Management / write APIs and app-specific business logic live outside this gem. Rich-text rendering delegates to the `contentstack_utils` gem. |

## Tech stack (at a glance)

| Area | Details |
| --- | --- |
| Language | Ruby **≥ 3.3** (see `contentstack.gemspec` and `.ruby-version`; team uses **3.3.x** locally). |
| Build | **Bundler** + **`contentstack.gemspec`**; `Gemfile` pulls the gemspec. |
| Tests | **RSpec 3** under `spec/**/*_spec.rb`; **`spec/spec_helper.rb`** loads WebMock and SimpleCov. |
| Lint / coverage | **SimpleCov** (via `spec_helper.rb`); HTML under `coverage/`. No RuboCop in this repo. **YARD** for API docs (see `rakefile.rb`, `.yardopts`). |
| Runtime deps | `activesupport`, `contentstack_utils` (~> 1.2); `Gemfile` pins **nokogiri** for security alignment. |

## Commands (quick reference)

| Command type | Command |
| --- | --- |
| Install deps | `bundle install` |
| Build gem | `gem build contentstack.gemspec` |
| Test | `bundle exec rspec` |
| Single file | `bundle exec rspec spec/path/to_spec.rb` |
| Lint / format | No RuboCop or formatter in-repo; match existing `lib/` and `spec/` style. |
| Docs (YARD) | `bundle exec rake yard` |

**CI / automation:** `.github/workflows/check-branch.yml` (PR branch rules toward `master`), `.github/workflows/release-gem.yml` (publish on release), plus `codeql-analysis.yml`, `sca-scan.yml`, `policy-scan.yml`, `issues-jira.yml`. There is no dedicated “run RSpec on every PR” workflow in-repo—run tests locally before opening a PR.

## Where the documentation lives: skills

| Skill | Path | What it covers |
| --- | --- | --- |
| Dev workflow | `skills/dev-workflow/SKILL.md` | Branches, bundler, commands, release notes alignment. |
| Ruby SDK (CDA) | `skills/contentstack-ruby-sdk/SKILL.md` | Public API, modules, errors, versioning, integration with `contentstack_utils`. |
| Ruby style & layout | `skills/ruby-style/SKILL.md` | File layout, idioms, and conventions for this codebase. |
| Testing | `skills/testing/SKILL.md` | RSpec, WebMock, fixtures, env vars, coverage. |
| Code review | `skills/code-review/SKILL.md` | PR checklist and review expectations. |
| Framework & packaging | `skills/framework/SKILL.md` | Bundler/gem packaging, HTTP stack (`Net::HTTP`), retries, optional proxy. |

An index with “when to use” hints is in `skills/README.md`.

## Using Cursor (optional)

If you use **Cursor**, `.cursor/rules/README.md` only points to **`AGENTS.md`**—same docs as everyone else.
