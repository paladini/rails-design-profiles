# frozen_string_literal: true

require_relative "test_helper"

class HelperTest < Minitest::Test
  def test_renders_a_style_tag_for_the_active_profile
    with_project("active: default\nprofiles:\n  default:\n    tokens:\n      color-primary: \"#2563eb\"\n") do
      view = ActionView::Base.empty
      view.extend(RailsDesignProfiles::Helper)

      assert_includes view.rails_design_profiles_tags, "<style id=\"rails-design-profiles\">:root {--rdp-color-primary: #2563eb;}</style>"
    end
  end
end

