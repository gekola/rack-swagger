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
        case
        when env['PATH_INFO'] =~ RESOURCE_DOC_JSON_MATCHER
          resource_doc = RESOURCE_DOC_JSON_MATCHER.match(env['PATH_INFO'])[1]
          display_file_or_404(:json, "#{@docs_dir}/#{resource_doc}.json")

        when env['PATH_INFO'] =~ ROOT_DOC_JSON_MATCHER
          display_file_or_404(:json, "#{@docs_dir}/swagger.json")

        else
          [404, {}, ["Not found"]]
        end
      end
    end
  end
end

