require_relative "lib/rails_design_profiles/version"

Gem::Specification.new do |spec|
  spec.name = "rails-design-profiles"
  spec.version = RailsDesignProfiles::VERSION
  spec.authors = ["Fernando Paladini"]
  spec.email = ["fnpaladini@gmail.com"]

  spec.summary = "Reviewable, versioned design-token profiles for Rails applications."
  spec.description = "Rails Design Profiles keeps public DESIGN.md references separate from executable design tokens. Install an openly licensed reference, review it with your team or AI tools, and define a versioned YAML token profile. The Rails helper emits the active profile as --rdp-* CSS custom properties, and Rails tasks switch the application-wide profile without copying third-party CSS, assets, or branding."
  spec.homepage = "https://paladini.github.io/rails-design-profiles/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["source_code_uri"] = "https://github.com/paladini/rails-design-profiles"
  spec.metadata["changelog_uri"] = "https://github.com/paladini/rails-design-profiles/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://paladini.github.io/rails-design-profiles/"
  spec.metadata["bug_tracker_uri"] = "https://github.com/paladini/rails-design-profiles/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    Dir["{lib,config,exe}/**/*", "LICENSE.txt", "README.md", "CHANGELOG.md", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md"]
  end
  spec.bindir = "exe"
  spec.require_paths = ["lib"]

  spec.add_dependency "actionview", ">= 7.1"
  spec.add_dependency "railties", ">= 7.1"
end
