module Rack
  module Swagger
    class IndexPageServer
      include ServerHelpers

      attr_reader :doc_url

      def initialize(doc_url)
        @doc_url = doc_url
      end

      def call(env)
        path = env['PATH_INFO']
        if path && !path.end_with?('/') && env['REQUEST_PATH']
          path += '/' if env['REQUEST_PATH'].end_with?('/')
        end

        case path
        when "/docs/"
          query = Rack::Utils.parse_nested_query(env["QUERY_STRING"])

          if query["url"] == doc_url
            display_file_or_404(:html, swagger_index_html_path)
          else
            redirect(env)
          end

        when "/docs"
          redirect(env)
        else
          [404, {}, ["Not found"]]
        end
      end

      private

      def redirect(env)
        res = Rack::Response.new
        res.redirect("#{env['SCRIPT_NAME']}/docs/?url=#{doc_url}")
        res.finish
      end
    end
  end
end
