module Rack
  module Swagger
    class IndexPageServer
      include ServerHelpers

      def call(env)
        case env['PATH_INFO']
        when "/docs/"
          query = Rack::Utils.parse_nested_query(env["QUERY_STRING"])

          if query["url"] == "api-docs"
            display_file_or_404(:html, swagger_index_html_path)

          else
            res = Rack::Response.new
            res.redirect("?url=" + "api-docs")
            res.finish
          end

        when "/docs"
          res = Rack::Response.new
          res.redirect("docs/?url=" + "api-docs")
          res.finish

        else
          [404, {}, ["Not found"]]
        end
      end
    end
  end
end

