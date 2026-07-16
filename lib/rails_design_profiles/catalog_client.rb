# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module RailsDesignProfiles
  class CatalogClient
    REPOSITORY = "VoltAgent/awesome-design-md"
    TREE_URL = "https://api.github.com/repos/#{REPOSITORY}/git/trees/main?recursive=1"
    RAW_URL = "https://raw.githubusercontent.com/#{REPOSITORY}/main/design-md/%<slug>s/DESIGN.md"

    def initialize(http_get: nil)
      @http_get = http_get || method(:get)
    end

    def slugs
      tree = JSON.parse(@http_get.call(TREE_URL)).fetch("tree")
      tree.filter_map { |entry| entry.fetch("path")[%r{\Adesign-md/([^/]+)/DESIGN\.md\z}, 1] }.sort
    rescue JSON::ParserError, KeyError => error
      raise CatalogError, "Unexpected catalog response: #{error.message}"
    end

    def download(slug)
      validate_slug!(slug)
      @http_get.call(format(RAW_URL, slug: slug))
    end

    private

    def get(url)
      uri = URI(url)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 5, read_timeout: 10) do |http|
        http.get(uri.request_uri, "User-Agent" => "rails-design-profiles/#{VERSION}")
      end
      return response.body if response.is_a?(Net::HTTPSuccess)

      raise CatalogError, "Catalog request failed (HTTP #{response.code})"
    rescue SocketError, Timeout::Error, Errno::ECONNREFUSED => error
      raise CatalogError, "Catalog request failed: #{error.message}"
    end

    def validate_slug!(slug)
      return if slug.is_a?(String) && slug.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/)

      raise CatalogError, "Invalid catalog slug: #{slug.inspect}"
    end
  end
end

