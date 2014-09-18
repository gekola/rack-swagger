module Rack
  module Swagger
    module ServerHelpers
      def swagger_dist_path
        ::File.expand_path("../../../../swagger-ui/dist", __FILE__)
      end

      def swagger_index_html_path
        ::File.join(swagger_dist_path, "index.html")
      end

      def display_file_or_404(type, file)
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
end
