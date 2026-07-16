# frozen_string_literal: true

require "pathname"
require "rails_design_profiles/version"
require "rails_design_profiles/profile_store"
require "rails_design_profiles/catalog_client"
require "rails_design_profiles/helper"
require "rails_design_profiles/railtie" if defined?(Rails::Railtie)

module RailsDesignProfiles
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class ProfileNotFound < Error; end
  class CatalogError < Error; end

  class << self
    attr_writer :root

    def root
      return @root if @root
      return Rails.root if defined?(Rails) && Rails.respond_to?(:root)

      Pathname.pwd
    end

    def store
      ProfileStore.new(root)
    end
  end
end

