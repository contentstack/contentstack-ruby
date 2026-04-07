---
name: ruby-style
description: Use when editing Ruby in lib/ or spec/ and you need layout, naming, and idioms consistent with this gem.
---

# Ruby style & layout – Contentstack Ruby SDK

## When to use

- Adding new files under **`lib/contentstack/`** or **`spec/`**
- Refactoring while keeping style aligned with existing code
- Choosing where to place helpers (e.g. `lib/util.rb` vs. domain classes)

## Instructions

### Layout

- **`lib/contentstack.rb`**: top-level module, YARD overview, delegates to **`contentstack_utils`** for render helpers.
- **`lib/contentstack/*.rb`**: one main concept per file (`client`, `api`, `query`, etc.).
- **`lib/util.rb`**: refinements / utilities consumed via `using Utility` where already established—follow existing patterns before introducing new global monkey patches.
- **`spec/*_spec.rb`**: mirror behavior under test; shared setup belongs in **`spec/spec_helper.rb`** only when it is truly global (WebMock, SimpleCov, default stubs).

### Conventions observed in this repo

- Prefer explicit validation in **`Contentstack::Client#initialize`** with **`Contentstack::Error`** for invalid configuration.
- Use **`ActiveSupport`** patterns (e.g. `present?`) where already used in **`Contentstack::API`** and client code—stay consistent within a file.
- Keep public method names stable; breaking renames require a major version strategy and **README** / **CHANGELOG** updates.

### Naming

- Match existing spellings in public APIs (e.g. `retryDelay`, `retryLimit`) for backward compatibility even if Ruby style guides suggest snake_case for new APIs—when adding **new** options, prefer **snake_case** unless extending an existing options hash that is documented with camelCase keys.

## References

- `skills/contentstack-ruby-sdk/SKILL.md` — public API boundaries
- `skills/testing/SKILL.md` — spec patterns
- `CHANGELOG.md` — record user-visible behavior changes
