module Rack
  module Swagger
    class IndexPageServer
      include ServerHelpers

      def call(env)
        case env['PATH_INFO']
        when "/docs/"
          display_file_or_404(:html, swagger_index_html_path)

        when "/docs"
          res = Rack::Response.new
          res.redirect("/docs/")
          res.finish

        else
          [404, {}, ["Not found"]]
        end
      end
    end
  end
end

