# frozen_string_literal: true

require_relative "test_helper"

class CatalogClientTest < Minitest::Test
  def test_lists_only_design_md_files
    response = { "tree" => [{ "path" => "design-md/claude/DESIGN.md" }, { "path" => "README.md" }] }.to_json
    client = RailsDesignProfiles::CatalogClient.new(http_get: ->(_url) { response })

    assert_equal ["claude"], client.slugs
  end

  def test_rejects_an_invalid_download_slug_before_requesting_the_network
    client = RailsDesignProfiles::CatalogClient.new(http_get: ->(_url) { flunk "network should not run" })

    assert_raises(RailsDesignProfiles::CatalogError) { client.download("../claude") }
  end

  def test_reports_an_unexpected_catalog_response
    client = RailsDesignProfiles::CatalogClient.new(http_get: ->(_url) { "not json" })

    assert_raises(RailsDesignProfiles::CatalogError) { client.slugs }
  end
end

