# Contributing

Thank you for helping make Rails interfaces more intentional and more maintainable.

## Before you start

- Use [Discussions](https://github.com/paladini/rails-design-profiles/discussions) for questions and proposals; open an issue when you have a reproducible bug or a focused feature.
- Keep pull requests narrow. Discuss changes that alter public configuration, task names, or output first.
- Never submit copied third-party CSS, assets, logos, or proprietary `DESIGN.md` content. References are context; executable tokens are authored and reviewed by the application team.

## Local workflow

```sh
bundle install
bundle exec rake test
gem build rails-design-profiles.gemspec
```

The CI suite verifies Ruby 3.1 with Rails 7.1 and current supported Ruby versions. Add a regression test for each behavior change and update the README when a public command, configuration key, or output changes.

## Pull requests

Explain the user problem, the chosen behavior, and how you verified it. Maintainers prioritize correctness, small APIs, accessible output, and changes that preserve the distinction between a design reference and a production theme.
