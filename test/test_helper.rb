# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "fileutils"
require "action_view"
require "rails_design_profiles"

class Minitest::Test
  def with_project(configuration)
    Dir.mktmpdir do |directory|
      root = Pathname(directory)
      config = root.join("config")
      FileUtils.mkdir_p(config)
      config.join("design_profiles.yml").write(configuration)
      previous_root = RailsDesignProfiles.root
      RailsDesignProfiles.root = root
      yield root
    ensure
      RailsDesignProfiles.root = previous_root
    end
  end
end

