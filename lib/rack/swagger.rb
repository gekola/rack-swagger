require "rack/swagger/version"
require "rack/swagger/sinatra_helpers"
require "rack/static"

module Rack
  module Swagger
    # Rack app for serving the swagger-ui front-end.
    #
    # Usage: in your config.ru, add:
    #
    #   run Rack::Swagger.app
    #
    # ...or to map to a route:
    #
    #   map '/docs' do
    #     run Rack::Swagger.app
    #   end
    def self.app(docs_dir)
      Rack::Builder.app do
        map "/docs/ui" do
          use Rack::Static, :urls => ["/"], :root => ::File.expand_path("../../../swagger-ui/dist", __FILE__)
          run lambda { [404, "Not found", {}] }
        end

        map "/docs" do
          use Rack::Static, :urls => ["/"], :root => docs_dir
          run lambda { [404, "Not found", {}] }
        end
      end
    end
  end
end
