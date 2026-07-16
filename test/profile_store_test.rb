# frozen_string_literal: true

require_relative "test_helper"

class ProfileStoreTest < Minitest::Test
  def test_renders_only_safe_css_variables_from_the_active_profile
    with_project(<<~YAML) do
      active: ocean
      profiles:
        ocean:
          tokens:
            color-primary: "#0ea5e9"
            font-body: "Inter, sans-serif"
            bad_name: "#fff"
            unsafe: "red; body { display: none }"
    YAML
      assert_equal "--rdp-color-primary: #0ea5e9;--rdp-font-body: Inter, sans-serif;", RailsDesignProfiles.store.css_variables
    end
  end

  def test_raises_for_an_unknown_active_profile
    with_project("active: missing\nprofiles: {}\n") do
      assert_raises(RailsDesignProfiles::ProfileNotFound) { RailsDesignProfiles.store.active_profile }
    end
  end

  def test_raises_for_invalid_yaml
    with_project("active: [\n") do
      assert_raises(RailsDesignProfiles::ConfigurationError) { RailsDesignProfiles.store.active_profile }
    end
  end

  def test_installs_a_reference_without_overwriting_an_existing_file
    with_project("active: default\nprofiles: {}\n") do |root|
      store = RailsDesignProfiles.store
      store.install_reference!("claude", "# Claude")

      assert_equal "# Claude", root.join("config/design_profiles/references/claude.md").read
      assert_raises(RailsDesignProfiles::ConfigurationError) { store.install_reference!("claude", "new") }
    end
  end

  def test_rejects_invalid_slugs
    with_project("active: default\nprofiles: {}\n") do
      assert_raises(RailsDesignProfiles::ConfigurationError) { RailsDesignProfiles.store.install_reference!("../escape", "x") }
    end
  end

  def test_activates_an_existing_profile
    with_project("active: first\nprofiles:\n  first: {}\n  second: {}\n") do
      RailsDesignProfiles.store.activate!("second")
      assert_equal "second", YAML.safe_load(File.read(File.join(RailsDesignProfiles.root, "config/design_profiles.yml")))["active"]
    end
  end
end

