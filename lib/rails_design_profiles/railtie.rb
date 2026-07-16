# frozen_string_literal: true

module RailsDesignProfiles
  class Railtie < Rails::Railtie
    initializer "rails_design_profiles.helper" do
      ActiveSupport.on_load(:action_view) { include RailsDesignProfiles::Helper }
    end

    rake_tasks do
      load File.expand_path("../tasks/rails_design_profiles_tasks.rake", __dir__)
    end
  end
end

