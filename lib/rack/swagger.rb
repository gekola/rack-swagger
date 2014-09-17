require "rack/swagger/version"
require "rack/swagger/sinatra_helpers"
require "rack/static"

module Rack
  module Swagger
    # Rack app for serving the swagger-ui front-end.
    #
    # Usage: in your config.ru, add:
    #
    #   run Rack::Swagger.app(File.expand_path("../docs/", __FILE__))
    #
    # ...or to map to a route:
    #
    #   map '/docs' do
    #     run Rack::Swagger.app(File.expand_path("../docs/", __FILE__))
    #   end
    def self.app(docs_dir)
      swagger_dist_path = ::File.expand_path("../../../swagger-ui/dist", __FILE__)

      Rack::Cascade.new([
        lambda { |env|
          if env['PATH_INFO'] =~ /^\/docs\/api-docs\/(.+)\/?/
            resource_doc = /^\/docs\/api-docs\/(.+)/.match(env['PATH_INFO'])[1]
            display_file_or_404(:json, "#{docs_dir}/#{resource_doc}.json")

          elsif env['PATH_INFO'] =~ /^\/docs\/api-docs\/?/
            display_file_or_404(:json, "#{docs_dir}/swagger.json")

          elsif env['PATH_INFO'] == "/docs/"
            display_file_or_404(:html, ::File.join(swagger_dist_path, "index.html"))

          elsif env['PATH_INFO'] == "/docs"
            res = Rack::Response.new
            res.redirect("/docs/")
            res.finish

          else
            [404, {}, ["Not found"]]
          end
        },
        Rack::Builder.new do
          map "/docs" do
            run Rack::Directory.new(swagger_dist_path)
          end
        end
      ])
    end

    def self.display_file_or_404(type, file)
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
    end
  end
end
