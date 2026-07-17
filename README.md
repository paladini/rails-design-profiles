# rails-design-profiles

[![CI](https://github.com/paladini/rails-design-profiles/actions/workflows/ci.yml/badge.svg)](https://github.com/paladini/rails-design-profiles/actions/workflows/ci.yml)
[![RubyGems](https://img.shields.io/gem/v/rails-design-profiles?logo=rubygems&label=RubyGems)](https://rubygems.org/gems/rails-design-profiles)
[![License](https://img.shields.io/github/license/paladini/rails-design-profiles)](LICENSE.txt)

**Versioned, reviewable design-token profiles for Rails applications.**

`rails-design-profiles` gives Rails teams a deliberate bridge between a visual reference and production UI code. Keep a `DESIGN.md` locally for people and AI tools to consult; turn only the choices your team approves into a small, versioned YAML token profile. The gem exposes the active profile as standard CSS custom properties.

It is not a Markdown-to-theme compiler. It does not install someone else's CSS, assets, or brand.

## Why it exists

A design reference can make an agent or contributor more consistent, but Markdown alone cannot safely change an application. Replacing a stylesheet to trial a visual direction is equally hard to review and easy to regret.

This gem makes the boundary explicit:

| Design reference | Production contract |
| --- | --- |
| `DESIGN.md` gives people and AI tools visual context. | `config/design_profiles.yml` contains the tokens your application actually serves. |
| Imported from a public, openly licensed catalog. | Authored, reviewed, versioned, and owned by your team. |
| Never executed by the gem. | Rendered as `--rdp-*` CSS custom properties. |

## Quick start

Add the gem and run the installer:

```ruby
# Gemfile
gem "rails-design-profiles"
```

```sh
bundle install
bin/rails generate rails_design_profiles:install
```

The generator creates `config/design_profiles.yml` and inserts this helper in the application layout's `<head>`:

```erb
<%= rails_design_profiles_tags %>
```

Use the emitted variables in whichever CSS setup your application already has:

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

## Define a profile

`config/design_profiles.yml` is the source of truth. The active profile is global to the Rails application and is evaluated for each response.

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

Each token becomes a CSS variable with the `rdp` prefix, for example `color-primary` becomes `--rdp-color-primary`. This keeps the contract visible in a diff and avoids silently changing component styles.

## Import a design reference

Version 0.1 uses the MIT-licensed [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) catalog only.

```sh
bin/rails design:list
bin/rails design:install[claude]
```

Installation archives the reference at `config/design_profiles/references/claude.md` and creates an empty `claude` profile. Read the reference, decide which ideas belong in your product, then add your own tokens. Existing references and profiles are never overwritten.

The gem is not affiliated with getdesign.md, VoltAgent, or any referenced brand.

## Switch profiles

After reviewing a profile, make it active with one explicit change:

```sh
bin/rails design:activate[claude]
```

The new application-wide profile takes effect on the next response. Per-session previews and query-string overrides are intentionally outside the first release.

## Compatibility

- Ruby 3.1+
- Rails 7.1+
- Standard CSS-variable consumers: the asset pipeline, Propshaft, Importmap, Tailwind, and custom CSS

## Project status and roadmap

The public API is intentionally small while the contract earns real-world use. Planned work includes profile validation and diagnostics, a development preview surface, more openly licensed reference adapters, and community-maintained example Rails applications.

## Contributing and support

Contributions are welcome. Start with [CONTRIBUTING.md](CONTRIBUTING.md), follow the [Code of Conduct](CODE_OF_CONDUCT.md), and use [GitHub Discussions](https://github.com/paladini/rails-design-profiles/discussions) for questions and early proposals. Report reproducible defects and focused feature requests through the [issue tracker](https://github.com/paladini/rails-design-profiles/issues). See [SECURITY.md](SECURITY.md) for responsible vulnerability reporting.

To work on the gem locally:

```sh
bundle install
bundle exec rake test
gem build rails-design-profiles.gemspec
```

## License

MIT. See [LICENSE.txt](LICENSE.txt).
