module RemoteDataCli

	class Handler

		def initialize(command)
			@command = command
		end

		def execute
			p "#{@command.action} execute #{@command.parameters}"
		end

	end

end
