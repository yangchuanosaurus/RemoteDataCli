module RemoteDataCli
	module Mapping

		class FieldArray
			attr_reader :name, :type, :item_type
			
			def initialize(name, item_type)
				@name = name
				@type = "Array"
				@item_type = item_type
			end

			def to_s
				inspect
			end

			def ==(other_item)
				@name == other_item.name && @item_type == other_item.item_type
			end

			def hash
				self.name.hash ^ self.item_type.hash
			end

			def eql?(other_item)
				@name == other_item.name && @item_type == other_item.item_type
			end
		end

	end
end
