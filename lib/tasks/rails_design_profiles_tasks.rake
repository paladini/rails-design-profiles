# frozen_string_literal: true

namespace :design do
  desc "List public DESIGN.md references from VoltAgent/awesome-design-md"
  task :list do
    RailsDesignProfiles::CatalogClient.new.slugs.each { |slug| puts slug }
  end

  desc "Download a public DESIGN.md reference and create a blank token profile"
  task :install, [:slug] => :environment do |_task, arguments|
    slug = arguments.fetch(:slug) { abort "Usage: rails design:install[slug]" }
    contents = RailsDesignProfiles::CatalogClient.new.download(slug)
    RailsDesignProfiles.store.install_reference!(slug, contents)
    puts "Installed #{slug}. Add tokens to config/design_profiles.yml before activating it."
  rescue RailsDesignProfiles::Error => error
    abort error.message
  end

  desc "Set the active design profile"
  task :activate, [:profile] => :environment do |_task, arguments|
    profile = arguments.fetch(:profile) { abort "Usage: rails design:activate[profile]" }
    RailsDesignProfiles.store.activate!(profile)
    puts "Active design profile: #{profile}"
  rescue RailsDesignProfiles::Error => error
    abort error.message
  end
end

