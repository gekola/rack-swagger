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
      swagger_dist_path = ::File.expand_path("../../../swagger-ui/dist", __FILE__)

      display_file = lambda { |type, path|
        if ::File.exists?(path)
          [
            200,
            {
              'Content-Type'  => type == :json ? 'application/json' : 'text/html',
              'Cache-Control' => 'public, max-age=86400'
            },
            ::File.open(path, ::File::RDONLY)
          ]
        else
          [404, {}, ["Not found"]]
        end
      }

      Rack::Cascade.new([
        lambda { |env|
          if env['PATH_INFO'] =~ /^\/docs\/(.+)/
            resource_doc = /^\/docs\/(.+)/.match(env['PATH_INFO'])[1]
            display_file[:json, "#{docs_dir}/#{resource_doc}.json"]

          elsif env['PATH_INFO'] == "/docs" && env['HTTP_ACCEPT'] == "application/json"
            display_file[:json, "#{docs_dir}/swagger.json"]

          elsif env['PATH_INFO'] == "/docs/"
            display_file[:html, ::File.join(swagger_dist_path, "index.html")]

          elsif env['PATH_INFO'] == "/docs"
            res = Rack::Response.new
            res.redirect("/docs/")
            res.finish
          end
        },
        Rack::Builder.new do
          map "/docs" do
            run Rack::Directory.new(swagger_dist_path)
          end
        end
      ])
    end
  end
end
