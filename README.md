# rails-design-profiles

[![CI](https://github.com/paladini/rails-design-profiles/actions/workflows/ci.yml/badge.svg)](https://github.com/paladini/rails-design-profiles/actions/workflows/ci.yml)
[![RubyGems](https://img.shields.io/gem/v/rails-design-profiles?logo=rubygems&label=RubyGems)](https://rubygems.org/gems/rails-design-profiles)
[![License](https://img.shields.io/github/license/paladini/rails-design-profiles)](LICENSE.txt)

**A design reference should influence your Rails UI without becoming an unreviewable theme generator.**

`rails-design-profiles` keeps the two jobs separate:

1. `DESIGN.md` gives your AI agent a clear visual reference.
2. A small YAML profile exposes the tokens your Rails application actually uses.

The result is a deliberate CSS-variable contract you can review, version, switch, and evolve with your team.

## Why this exists

AI can read a `DESIGN.md`, but Markdown alone does not change an application. Conversely, replacing an entire stylesheet to try a visual direction is risky and hard to review.

This gem gives Rails applications a narrow bridge between the two: references stay local and explicit; CSS variables are emitted from an active profile; your components decide which tokens to consume.

## Install

```ruby
# Gemfile
gem "rails-design-profiles"
```

```sh
bundle install
bin/rails generate rails_design_profiles:install
```

The generator adds a profile file and inserts the helper into `app/views/layouts/application.html.erb`:

```erb
<%= rails_design_profiles_tags %>
```

Use the resulting variables in your own CSS:

```css
body {
  color: var(--rdp-color-text);
  background: var(--rdp-color-surface);
  font-family: var(--rdp-font-body);
}

.button {
  background: var(--rdp-color-primary);
  padding: var(--rdp-space-page);
}
```

## The profile contract

`config/design_profiles.yml` is the source of truth for production tokens. Token names become `--rdp-*` CSS variables.

```yaml
active: editorial
profiles:
  editorial:
    reference: config/design_profiles/references/claude.md
    tokens:
      color-primary: "#c15f3c"
      color-surface: "#f8f6f2"
      color-text: "#24211e"
      font-body: "Newsreader, Georgia, serif"
      space-page: "1.5rem"
```

The active profile is global to the app and is resolved for every response. Version 0.1 does not include per-session or query-string overrides.

## Bring a public reference into your project

The v0.1 catalog uses only the MIT-licensed [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) collection.

```sh
bin/rails design:list
bin/rails design:install[claude]
```

Installation stores the reference in `config/design_profiles/references/claude.md` and creates an empty `claude` profile. Read that reference with your agent, choose the tokens that fit your product, and add them deliberately to YAML.

Switch profiles with:

```sh
bin/rails design:activate[claude]
```

The gem never copies third-party CSS, assets, or branding. It is not affiliated with getdesign.md, VoltAgent, or any referenced brand.

## How it works

```text
DESIGN.md reference ──> team / AI design decisions ──> design_profiles.yml
                                                            │
                                                            ▼
                                              <style> --rdp-* variables
                                                            │
                                                            ▼
                                                   your Rails components
```

This is intentionally not a Markdown-to-CSS compiler. It preserves human judgment at the point where visual decisions become production code.

## Compatibility

- Ruby 3.1+
- Rails 7.1+
- Asset pipeline, Propshaft, Importmap, Tailwind, and custom CSS all work because the output is standard CSS variables.

## Community

- Ask questions and share workflows in [Discussions](https://github.com/paladini/rails-design-profiles/discussions).
- Report reproducible defects or focused feature requests through the issue templates.
- Read [CONTRIBUTING.md](CONTRIBUTING.md), [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md), [SUPPORT.md](SUPPORT.md), and [SECURITY.md](SECURITY.md) before participating.

### Roadmap

- [ ] Profile validation and diagnostics
- [ ] A profile preview surface for development
- [ ] More import adapters for openly licensed design references
- [ ] Community-maintained example Rails applications

## Development

```sh
bundle install
bundle exec rake test
gem build rails-design-profiles.gemspec
```

## License

MIT. See [LICENSE.txt](LICENSE.txt).
