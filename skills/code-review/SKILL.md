---
name: code-review
description: Use when authoring or reviewing a pull request for contentstack-ruby—scope, tests, API stability, and documentation.
---

# Code review – Contentstack Ruby SDK

## When to use

- Opening a PR against **`development`** (or the team’s active integration branch)
- Reviewing a colleague’s change for risk, API impact, or test gaps
- Deciding whether a change needs **CHANGELOG** / version bump / **README** updates

## Instructions

### Blocker (must fix before merge)

- **Tests:** New or changed behavior lacks **`spec`** coverage where feasible, or **`bundle exec rspec`** would fail.
- **Security / secrets:** No real API keys, tokens, or stack data committed; tests use fixtures and WebMock.
- **Breaking changes:** Public method signatures or documented behavior changed without version strategy and **CHANGELOG** / **README** updates as appropriate.

### Major (strongly prefer fixing)

- **WebMock:** New HTTP paths or hosts not stubbed in **`spec/spec_helper.rb`**, causing flaky or network-dependent specs.
- **Error handling:** New failure modes do not use **`Contentstack::Error`** / **`ErrorMessages`** consistently with the rest of the client.
- **Dependencies:** **`contentstack.gemspec`** or **`Gemfile`** changes without a clear reason (security pins are documented in comments—preserve that intent).

### Minor (nice to have)

- YARD or **README** examples for new public options
- Clear commit messages and PR description linking to internal tickets if applicable

### Process notes

- **`master`** is protected by **`.github/workflows/check-branch.yml`**; follow team flow (**`staging`** → **`master`**) for production promotion.
- Run **`bundle exec rspec`** locally; CI may not run the full suite on every PR in this repository.

## References

- `skills/dev-workflow/SKILL.md` — branches and commands
- `skills/testing/SKILL.md` — fixtures and stubs
- `skills/contentstack-ruby-sdk/SKILL.md` — API surface
- [Reference PR pattern (Cursor rules + skills)](https://github.com/contentstack/contentstack-utils-swift/pull/36)
