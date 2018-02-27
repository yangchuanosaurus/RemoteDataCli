module RemoteDataCli
	module Mapping

		class Field
			attr_reader :name, :type

			def initialize(name, type)
				@name = name
				@type = type
			end

			def to_s
				inspect
			end

			def ==(other_item)
				@name == other_item.name && @type == other_item.type
			end

			def hash
				self.name.hash ^ self.type.hash
			end

			def eql?(other_item)
				@name == other_item.name && @type == other_item.type
			end
		end

	end
end
