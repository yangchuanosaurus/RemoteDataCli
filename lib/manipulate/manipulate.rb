require 'json'

require_relative 'field'
require_relative 'field_array'

module RemoteDataCli
	module Mapping

		class Manipulate

			def initialize(name)
				@name = upcase(name)
				@class_instances = Hash.new
			end

			def generate(json)
				data_json = JSON.parse(json)

				if data_json.is_a?(Hash)
					manipulate_hash(@name, data_json)
				elsif data_json.is_a?(Array)
					manipulate_array("#{@name}Item", data_json)
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

				def join_name(name, parent_name = nil)
					if !parent_name.nil?
						"#{upcase(parent_name)}#{upcase(name)}"
					else
						upcase(name)
					end
				end

				def add_field(name, field, parent_name = nil)
					model_name = join_name(model_name(name), parent_name)
					@class_instances[model_name] = Array.new if @class_instances[model_name].nil?
					@class_instances[model_name] << field # todo should update if the item in model_name exits
					@class_instances[model_name] = @class_instances[model_name].uniq
				end

				def manipulate_hash(name, data_hash, parent_name = nil)
					data_hash.keys.each do |key|
						value = data_hash[key]
						if value.is_a?(Hash)
							add_field(name, Field.new(key, model_name(join_name(key, name))), parent_name)
						elsif value.is_a?(Array)
							model_name = "#{name}#{upcase(key)}Item"
							add_field(name, FieldArray.new(key, join_name(model_name(model_name), parent_name)), parent_name)
						else
							add_field(name, Field.new(key, value.class), parent_name)
						end
					end

					data_hash.map do |key, value|
						if value.is_a?(Hash)
							manipulate_hash(key, value, name)
						elsif value.is_a?(Array)
							p_name = parent_name.nil? ? name : "#{upcase(parent_name)}#{upcase(name)}"
							model_name = "#{upcase(key)}Item"
							
							manipulate_array("#{model_name}", value, p_name)
						end
					end
				end

				def manipulate_array(name, data_array, parent_name)
					data_array.each do |value|
						
						if value.is_a?(Hash)
							manipulate_hash(name, value, upcase(parent_name))
						elsif value.is_a?(Array)
							model_name = "#{upcase(name)}Item"
							manipulate_array(name, value, join_name(name, parent_name))
						else
							add_field(name, Field.new(model_name(value), "Array"))
						end

					end
				end
		end

	end
end