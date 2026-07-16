# frozen_string_literal: true

require_relative "test_helper"
require "rails/generators"
require "generators/rails_design_profiles/install/install_generator"

class InstallGeneratorTest < Minitest::Test
  def test_creates_configuration_and_adds_the_helper_once
    Dir.mktmpdir do |directory|
      layout = File.join(directory, "app/views/layouts/application.html.erb")
      FileUtils.mkdir_p(File.dirname(layout))
      File.write(layout, "<html>\n  <head>\n  </head>\n</html>\n")

      generator = RailsDesignProfiles::Generators::InstallGenerator.new([], {}, destination_root: directory)
      generator.invoke_all
      generator.invoke_all

      assert File.exist?(File.join(directory, "config/design_profiles.yml"))
      assert_equal 1, File.read(layout).scan("rails_design_profiles_tags").size
    end
  end
end
