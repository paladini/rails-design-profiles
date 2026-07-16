# frozen_string_literal: true

require "fileutils"
require "yaml"

module RailsDesignProfiles
  class ProfileStore
    CONFIG_PATH = "config/design_profiles.yml"

    def initialize(root)
      @root = Pathname(root)
    end

    def active_profile
      profile_named(data.fetch("active"))
    rescue KeyError
      raise ConfigurationError, "Missing active profile in #{config_path}"
    end

    def css_variables
      tokens = active_profile.fetch("tokens", {})
      unless tokens.is_a?(Hash)
        raise ConfigurationError, "Profile tokens must be a mapping in #{config_path}"
      end

      tokens.filter_map do |name, value|
        next unless valid_token?(name, value)

        "--rdp-#{name}: #{value};"
      end.join
    end

    def install_reference!(slug, contents)
      validate_slug!(slug)
      reference_path = references_path.join("#{slug}.md")
      raise ConfigurationError, "Reference already exists: #{reference_path}" if reference_path.exist?

      config = data
      profiles = config.fetch("profiles")
      if profiles.key?(slug)
        raise ConfigurationError, "Profile already exists: #{slug}"
      end

      FileUtils.mkdir_p(reference_path.dirname)
      reference_path.write(contents)
      profiles[slug] = {
        "reference" => reference_path.relative_path_from(@root).to_s,
        "tokens" => {}
      }
      write(config)
    rescue StandardError
      FileUtils.rm_f(reference_path) if defined?(reference_path) && reference_path&.exist?
      raise
    end

    def activate!(name)
      config = data
      profile_named(name, config)
      config["active"] = name
      write(config)
    end

    private

    def data
      raise ConfigurationError, "Missing configuration: #{config_path}" unless config_path.exist?

      parsed = YAML.safe_load(config_path.read, permitted_classes: [], aliases: false)
      unless parsed.is_a?(Hash) && parsed["profiles"].is_a?(Hash)
        raise ConfigurationError, "Expected active and profiles mappings in #{config_path}"
      end

      parsed
    rescue Psych::Exception => error
      raise ConfigurationError, "Invalid YAML in #{config_path}: #{error.message}"
    end

    def write(config)
      config_path.write(YAML.dump(config))
    end

    def profile_named(name, config = data)
      profile = config.fetch("profiles")[name]
      raise ProfileNotFound, "Unknown design profile: #{name}" unless profile.is_a?(Hash)

      profile
    end

    def config_path
      @root.join(CONFIG_PATH)
    end

    def references_path
      @root.join("config/design_profiles/references")
    end

    def validate_slug!(slug)
      return if slug.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)

      raise ConfigurationError, "Invalid catalog slug: #{slug.inspect}"
    end

    def valid_token?(name, value)
      name.is_a?(String) && value.is_a?(String) &&
        name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/) &&
        value.match?(/\A[a-zA-Z0-9#%.,()\s\/'\"+*_\-]+\z/)
    end
  end
end

