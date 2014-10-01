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
            ::StringIO.new(display_file(type, file))
          ]
        else
          [404, {}, ["Not found"]]
        end
      end

      def display_file(type, file)
        @files ||= {}
        @files[file] ||= begin
                           contents = ::File.read(file)
                           contents.gsub!(/ENV\[SWAGGER_([A-Z0-9_]+)\]/) { |match| ENV["SWAGGER_#{$1}"] } if type == :json
                           contents
                         end
      end
    end
  end
end
