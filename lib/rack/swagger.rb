require "rack/swagger/version"
require "rack/swagger/sinatra_helpers"
require "rack/static"

module Rack
  module Swagger
    RESOURCE_DOC_JSON_MATCHER = /^\/docs\/api-docs\/(.+)\/?/
    ROOT_DOC_JSON_MATCHER     = /^\/docs\/api-docs\/?/
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
          case
          when env['PATH_INFO'] =~ RESOURCE_DOC_JSON_MATCHER
            resource_doc = RESOURCE_DOC_JSON_MATCHER.match(env['PATH_INFO'])[1]
            display_file_or_404(:json, "#{docs_dir}/#{resource_doc}.json")

          when env['PATH_INFO'] =~ ROOT_DOC_JSON_MATCHER
            display_file_or_404(:json, "#{docs_dir}/swagger.json")

          when env['PATH_INFO'] == "/docs/"
            display_file_or_404(:html, ::File.join(swagger_dist_path, "index.html"))

          when env['PATH_INFO'] == "/docs"
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
      if ::File.exists?(file)
        [
          200,
          {
            'Content-Type'  => type == :json ? 'application/json' : 'text/html',
            'Cache-Control' => 'public, max-age=86400'
          },
          ::File.open(file, ::File::RDONLY)
        ]
      else
        [404, {}, ["Not found"]]
      end
    end
  end
end
