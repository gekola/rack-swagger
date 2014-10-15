module Rack
  module Swagger
    module ServerHelpers
      def swagger_dist_path
        ::File.expand_path("../../../../swagger-ui/dist", __FILE__)
      end

      def swagger_index_html_path
        ::File.join(swagger_dist_path, "index.html")
      end

      def display_file_or_404(type, file, root_or_resource=nil)
        if ::File.exists?(file)
          [
            200,
            {
              'Content-Type'  => type == :json ? 'application/json' : 'text/html',
              'Cache-Control' => 'public, max-age=86400'
            },
            ::StringIO.new(display_file(type, file, root_or_resource))
          ]
        else
          [404, {}, ["Not found"]]
        end
      end

      def display_file(type, file, root_or_resource=nil)
        @files ||= {}
        @files[file] ||= begin
                           contents = ::File.read(file)
                           contents = overwrite_base_path(contents, base_path_value(root_or_resource)) if type == :json
                           contents
                         end
      end

      def base_path_value(root_or_resource=nil)
        if root_or_resource == :root
          @opts[:overwrite_base_path] + "/docs/api-docs"
        else
          @opts[:overwrite_base_path]
        end
      end

      def overwrite_base_path(contents, value)
        if value
          contents = JSON.parse(contents)
          contents["basePath"] = value
          contents.to_json
        else
          contents
        end
      end
    end
  end
end
