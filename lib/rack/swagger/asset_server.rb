module Rack
  module Swagger
    class AssetServer
      def initialize
        @app = Rack::Builder.new do
          map "/docs" do
            run Rack::Directory.new(ServerHelpers.swagger_dist_path)
          end
        end
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end

