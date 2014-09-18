module Rack
  module Swagger
    class IndexPageServer
      include ServerHelpers

      def call(env)
        case
        when env['PATH_INFO'] == "/docs/"
          display_file_or_404(:html, ServerHelpers.swagger_index_html_path)

        when env['PATH_INFO'] == "/docs"
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

