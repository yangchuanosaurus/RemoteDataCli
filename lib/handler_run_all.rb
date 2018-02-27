require_relative 'handler'
require_relative 'run/all_action'

module RemoteDataCli

	class RunAllActions < Handler

		def execute
			raise RunAllActionsError.new("Usage: RemoteDataCli run qa") until @command.parameters.size >= 1

			host_alias = @command.parameters[0]

			# iterator all the files for getting all actions
			actions = Dir.glob('./actions/**/*').select { |path| path.downcase =~ /_(get|post)\.json/ }

			actions.each { |path| run_action(host_alias, path) }

			"All actions execute finished."
		end

		def run_action(host_alias, path)
			Run::AllAction.new(host_alias, path).run
		end

	end

	class RunAllActionsError < StandardError
	end

end