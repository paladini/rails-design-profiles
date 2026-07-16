# frozen_string_literal: true

require "rails/generators"

module RailsDesignProfiles
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_configuration
        template "design_profiles.yml", "config/design_profiles.yml" unless File.exist?(path("config/design_profiles.yml"))
      end

      def add_style_helper_to_layout
        layout = "app/views/layouts/application.html.erb"
        return unless File.exist?(path(layout))
        return if File.read(path(layout)).include?("rails_design_profiles_tags")

        inject_into_file layout, "    <%= rails_design_profiles_tags %>\n", before: "  </head>\n"
      end

      private

      def path(relative_path)
        File.join(destination_root, relative_path)
      end
    end
  end
end
