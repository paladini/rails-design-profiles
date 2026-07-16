# rails-design-profiles

`rails-design-profiles` keeps a `DESIGN.md` reference beside an executable, versioned CSS-token profile for a Rails application.

It does not copy another site's CSS, assets, or branding. A `DESIGN.md` is context for an AI agent; the YAML tokens in your application are the deliberate, reviewable values that your UI actually uses.

## Install

Add the gem to your application:

```ruby
gem "rails-design-profiles"
```

Then install its configuration and helper:

```sh
bin/rails generate rails_design_profiles:install
```

The generator creates `config/design_profiles.yml` and adds this to your application layout:

```erb
<%= rails_design_profiles_tags %>
```

Use the resulting CSS variables in application CSS:

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

## Public DESIGN.md references

Version 0.1.0 reads only the public, MIT-licensed [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) collection.

```sh
bin/rails design:list
bin/rails design:install[claude]
```

Installation saves the source reference at `config/design_profiles/references/claude.md` and creates a blank `claude` profile. Review the reference with an AI agent, then deliberately add the CSS tokens you want to use:

```yaml
active: claude
profiles:
  claude:
    reference: config/design_profiles/references/claude.md
    tokens:
      color-primary: "#c15f3c"
      color-surface: "#f8f6f2"
      color-text: "#24211e"
      font-body: "Inter, sans-serif"
```

Switch an existing profile with:

```sh
bin/rails design:activate[claude]
```

The active profile is global to the application and is read on each response. The gem intentionally does not provide query-parameter or session-based theme overrides in v0.1.0.

## Development

```sh
bundle install
bundle exec rake test
gem build rails-design-profiles.gemspec
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution expectations.

## License

MIT. The catalog references are independent analyses of publicly observable visual patterns. This project is not affiliated with getdesign.md, VoltAgent, or the referenced brands.
