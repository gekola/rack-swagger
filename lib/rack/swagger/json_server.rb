module Rack
  module Swagger
    class JsonServer
      include ServerHelpers

      RESOURCE_DOC_JSON_MATCHER = /^\/docs\/api-docs\/(.+)\/?/
      ROOT_DOC_JSON_MATCHER     = /^\/docs\/api-docs\/?/

      def initialize(docs_dir)
        @docs_dir = docs_dir
      end

      def call(env)
        case env['PATH_INFO']
        when RESOURCE_DOC_JSON_MATCHER
          resource_doc = $1
          display_file_or_404(:json, "#{@docs_dir}/#{resource_doc}.json")

        when ROOT_DOC_JSON_MATCHER
          display_file_or_404(:json, "#{@docs_dir}/swagger.json")

        else
          [404, {}, ["Not found"]]
        end
      end
    end
  end
end

