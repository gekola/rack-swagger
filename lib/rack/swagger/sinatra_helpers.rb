module Rack
  module Swagger
    module SinatraHelpers
      def self.get_all_routes(*apps)
        routes = {}
        apps.each do |app|
          routes_by_verb = get_routes app

          HTTP_VERBS.each do |verb|
            unless routes_by_verb[ verb ].nil?
              routes[ verb ] ||= []
              routes[ verb ] += routes_by_verb[ verb ]
            end
          end
        end
        routes
      end

      private

      HTTP_VERBS = %w(  GET
                        HEAD
                        POST
                        PUT
                        DELETE
                        TRACE
                        OPTIONS
                        CONNECT
                        PATCH )

      def self.expand_routes(routes)
        all_routes = routes.map do |r|
          path = r[0].to_s

          # this is to undo sinatra/base.rb#compile()
          path = path.gsub(/^\(\?-mix:\\A\\/, "").
            gsub(/\\z\)$/, "").
            gsub(/\\\/\?$/,"").
            gsub("([^#]+)?", "").
            gsub("(?:\\.|%2[Ee])",".").
            gsub("\\/","/")

          # this is to replace the regexes with param names from the array
          r[1].each do |param|
            path = path.sub("([^/?#]+)", "{#{param}}")
          end

          # this is to split paths with optional pieces into more than one path
          alternate_paths = []
          path.split("/?").each do |segment|
            if alternate_paths.last
              alternate_paths << alternate_paths.last + "/" + segment.sub(/\?$/, "")
            else
              alternate_paths << segment.sub(/\?$/, "")
            end
          end

          if alternate_paths.empty?
            path
          else
            alternate_paths
          end
        end

        all_routes.flatten
      end

      def self.get_routes(app)
        routes_by_verb = {}
        HTTP_VERBS.each do |verb|
          routes = app.routes[verb]
          routes_by_verb[ verb ] = routes.nil? ? nil : expand_routes( routes )
        end
        routes_by_verb
      end
    end
  end
end
