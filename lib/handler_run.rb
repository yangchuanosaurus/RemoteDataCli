require_relative 'handler'
require_relative 'run/action'

module RemoteDataCli

	class RunAction < Handler

		def execute
			raise StandardError.new("Usage: RemoteDataCli run qa method /{path}/action") until @command.parameters.size >= 3

			host_alias = @command.parameters[0]
			http_method = @command.parameters[1]
			path = "actions#{@command.parameters[2]}"
			
			action = path.split('/')[-1]

			run_action(host_alias, path, http_method)

		end

		def run_action(host_alias, path, http_method)
			Run::Action.new(host_alias, path, http_method).run
		end

	end

	class RunActionError < StandardError
	end

end
