require 'active_support/inflector/inflections'
require 'active_support/inflections'
require 'active_support/inflector/methods'
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
      rescue
        puts "#{__FILE__}:#{__LINE__}: URL not parsable."
        {}
      end

      def traverse(gp='root', parent='root', obj, &blk)
        case obj
        when Hash
          type = to_model_name(parent)
          blk.call(gp, parent, type)
          obj.each {|k,v| traverse(parent, k, v, &blk) }
        when Array
          type = to_model_name(parent, singularize: true)
          blk.call(gp, parent, "[#{type}]")
          obj.each {|v| traverse(parent, "#{type}", v, &blk) }
        else
          blk.call(gp, parent, "#{obj.class}")
        end
      end

      def to_model_name(str, singularize: false)
        str2 = ActiveSupport::Inflector.camelize(str)
        str2 = ActiveSupport::Inflector.singularize(str2) if singularize
        "Model_#{str2}"
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
          { "$ref" => ruby_type.gsub(/^Model_/, "") }
        end
      end

      def generate_models(json, root_name, debug=false)
        models = {}

        traverse('root', json) do |parent, obj_name, obj_type|
          if ['FalseClass', 'TrueClass'].include? obj_type
            obj_type = "Boolean"
          end

          if debug
            puts sprintf("parent: %30s obj_name: %20s obj_type: %20s", parent, obj_name, obj_type.to_s[0...20])
          end

          if obj_type == "NilClass"
            # skip

          elsif parent.match(/^Model_/)
            parent_wo_model = parent.gsub(/^Model_/, "")

            unless models[parent_wo_model]
              models[parent_wo_model] = new_model(parent_wo_model)
            end

            models[parent_wo_model][:properties][obj_name] = new_property(obj_type)
          elsif !parent.match(/^Model_/) && !obj_name.match(/^Model_/)
            c_parent = to_model_name(parent).gsub(/^Model_/, "")

            unless models[c_parent]
              models[c_parent] = new_model(c_parent)
            end

            models[c_parent][:properties][obj_name] = new_property(obj_type)
          end
        end

        root = models["Root"]
        models.delete("Root")
        root[:properties].delete("root")
        root[:id] = root_name

        models[root_name] = root
        models
      end
    end
  end
end
