require 'active_support/inflector/inflections'
require 'active_support/inflections'
require 'json'
require 'pp'

# A set of scripts for generating the "models" portion of the resource JSON
# files.
#
# Usage:
#    include Rack::Swagger::RoutesToModels
#    models = generate_models(get_json("http://{URL}"))
module Rack
  module Swagger
    module RoutesToModels
      def get_json(url)
        raw  = `curl "#{url}"`
        json = JSON.parse raw
      end

      def traverse(gp='root', parent='root', obj, &blk)
        case obj
        when Hash
          type = ActiveSupport::Inflector.camelize(parent)
          blk.call(gp, parent, type)
          obj.each {|k,v| traverse(parent, k, v, &blk) }
        when Array
          type = ActiveSupport::Inflector.singularize(ActiveSupport::Inflector.camelize(parent))
          blk.call(gp, parent, "[#{type}]")
          obj.each {|v| traverse(parent, "#{type}", v, &blk) }
        else
          blk.call(gp, parent, "#{obj.class}")
        end
      end


      def new_model(name)
        {id: name, properties: {}}
      end

      def new_property(ruby_type)
        case ruby_type
        when "String"
          {type: "string"}
        when "Boolean"
          {type: "boolean", format: "boolean"}
        when "Float"
          {type: "number", format: "float"}
        when "Fixnum"
          {type: "integer", format: "int64"}
        when /\[(.+)\]/
          {type: "array", items: new_property($1) }
        else
          { "$ref" => ruby_type }
        end
      end

      def generate_models(json)
        models = {}

        traverse('root', json) do |parent, obj_name, obj_type|
          if ['FalseClass', 'TrueClass'].include? obj_type
            obj_type = "Boolean"
          end

          puts sprintf("parent: %30s obj_name: %20s obj_type: %20s", parent, obj_name, obj_type.to_s[0...20])

          if obj_type == "NilClass"
            # skip

          elsif parent[0].match /[A-Z]/
            unless models[parent]
              models[parent] = new_model(parent)
            end

            models[parent][:properties][obj_name] = new_property(obj_type)
          elsif parent[0].match(/[a-z]/) && obj_name[0].match(/[a-z]/)
            c_parent = ActiveSupport::Inflector.camelize(parent)

            unless models[c_parent]
              models[c_parent] = new_model(c_parent)
            end

            models[c_parent][:properties][obj_name] = new_property(obj_type)
          end
        end

        models.delete("Root")
        models
      end
    end
  end
end
