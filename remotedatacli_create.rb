require_relative 'remotedatacli_handler'

module RemoteDataCli

	class Creator < Handler

		def initialize(command)
			@command = command
		end

		# def execute
		# 	p "#{@command.action} execute #{@command.parameters}"
		# end
	end

end

# creator = RemoteDataCli::Creator.new("app")
# puts creator