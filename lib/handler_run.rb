require_relative 'handler'
require_relative 'run/action'

module RemoteDataCli

	class RunAction < Handler

		def execute
			raise StandardError.new("Usage: RemoteDataCli run root_path path method action") until @command.parameters.size >= 2

			path_array = ["actions"]
			@command.parameters[0...-2].each { |path| path_array << path }
			
			path = path_array.join("/")
			http_method = @command.parameters[-2]
			action = @command.parameters[-1]

			run_action(path, http_method, action)

		end

		def run_action(path, http_method, action)
			Run::Action.new(path, action, http_method).run
		end

	end

	class RunActionError < StandardError
	end

end
