module Rack
  module Swagger
    class AssetServer
      include ServerHelpers

      def initialize
        dist_path = swagger_dist_path

        @app = Rack::Builder.new do
          map "/docs" do
            run Rack::Directory.new(dist_path)
          end
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end

