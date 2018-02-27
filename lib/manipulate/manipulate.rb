require 'json'

require_relative 'field'
require_relative 'field_array'

module RemoteDataCli
	module Mapping

		class Manipulate

			def initialize
				@class_instances = Hash.new
			end

			def generate(name, json)
				data_json = JSON.parse(json)

				if data_json.is_a?(Hash)
					manipulate_hash(upcase(name), data_json)
				elsif data_json.is_a?(Array)
					manipulate_array("#{upcase(name)}Item", data_json)
				end

				@class_instances
			end

			private
				def upcase(str)
					"#{str[0].upcase}#{str[1..-1]}"
				end

				def model_name(name)
					"#{upcase(name)}.model"
				end

				def add_field(name, field)
					model_name = model_name(name)
					@class_instances[model_name] = Array.new if @class_instances[model_name].nil?
					@class_instances[model_name] << field # todo should update if the item in model_name exits
					@class_instances[model_name] = @class_instances[model_name].uniq
				end

				def manipulate_hash(name, data_hash)
				data_hash.keys.each do |key|
					value = data_hash[key]
					if value.is_a?(Hash)
						add_field(name, Field.new(key, model_name(key)))
					elsif value.is_a?(Array)
						add_field(name, FieldArray.new(key, "#{model_name(key + "Item")}"))
					else
						add_field(name, Field.new(key, value.class))
					end
				end

				data_hash.map do |key, value|
					if value.is_a?(Hash)
						manipulate_hash(key, value)
					elsif value.is_a?(Array)
						manipulate_array("#{key}Item", value)
					end
				end
			end

			def manipulate_array(name, data_array)
				data_array.each do |value|
					
					if value.is_a?(Hash)
						manipulate_hash(name, value)
					elsif value.is_a?(Array)
						manipulate_array(name, value)
					else
						add_field(name, Field.new(model_name(value), "Array"))
					end

				end
			end
		end

	end
end