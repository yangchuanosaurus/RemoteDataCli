require_relative 'remotedatacli_handler'

module RemoteDataCli

	class AddAction < Handler

		def initialize(command)
			@command = command
		end

		# def execute
		# 	p "#{@command.action} execute #{@command.parameters}"
		# end

	end

end
