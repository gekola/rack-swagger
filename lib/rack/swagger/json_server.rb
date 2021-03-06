module Rack
  module Swagger
    class JsonServer
      include ServerHelpers

      RESOURCE_DOC_JSON_MATCHER = /^\/docs\/api-docs\/(.+)\/?/
      ROOT_DOC_JSON_MATCHER     = /^\/docs\/api-docs\/?/

      def initialize(docs_dir, opts)
        @docs_dir = docs_dir
        @opts = opts
      end

      def call(env)
        case env['PATH_INFO']
        when RESOURCE_DOC_JSON_MATCHER
          resource_doc = $1
          display_file_or_404(:json, "#{@docs_dir}/#{resource_doc}.json", :resource)

        when ROOT_DOC_JSON_MATCHER
          display_file_or_404(:json, "#{@docs_dir}/swagger.json", :root)

        else
          [404, {}, ["Not found"]]
        end
      end
    end
  end
end

