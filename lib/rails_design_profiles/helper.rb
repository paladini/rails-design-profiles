# frozen_string_literal: true

module RailsDesignProfiles
  module Helper
    def rails_design_profiles_tags
      css = RailsDesignProfiles.store.css_variables
      return "".html_safe if css.empty?

      content_tag(:style, ":root {#{css}}".html_safe, id: "rails-design-profiles")
    end
  end
end

