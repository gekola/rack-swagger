require "rack/swagger/server_helpers"
require "rack/swagger/asset_server"
require "rack/swagger/index_page_server"
require "rack/swagger/json_server"

require "rack/swagger/sinatra_helpers"
require "rack/swagger/version"

module Rack
  module Swagger
    # Rack app for serving the swagger-ui front-end and your JSON-formatted
    # Swagger doc files.
    #
    # Description:
    #   The app will serve the swagger-ui front-end at /docs/, and redirect
    #   requests for /docs to /docs/. It will serve the root Swagger doc
    #   file at /docs/api-docs, and resource files in a subpath of /docs/api-docs,
    #   such as /docs/api-docs/pet for the "pet" resource. This mimics the way
    #   the Pet Store demo is set up.
    #
    #   See: http://petstore.swagger.wordnik.com/
    #
    # Parameters:
    #   docs_dir: a String containing the path to the directory with your root
    #   Swagger JSON doc file (called swagger.json) and all resource-specific
    #   doc files (for example, pet.json for the "pet" resource).
    #
    # Usage:
    #   In your config.ru, add:
    #
    #   run Rack::Swagger.app(File.expand_path("../docs/", __FILE__))
    #
    def self.app(docs_dir, opts={})
      if docs_dir.is_a? Hash
        opts = docs_dir
      end

      doc_url = opts[:url] || 'api-docs'

      Rack::Cascade.new([
        (JsonServer.new(docs_dir, opts) if docs_dir),
        IndexPageServer.new(doc_url),
        AssetServer.new
      ].compact)
    end
  end
end
