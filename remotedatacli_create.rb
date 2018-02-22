require_relative 'remotedatacli_handler'
require_relative 'core/cli/templates'
require_relative 'core/cli/file_io'

module RemoteDataCli

	class Creator < Handler

		def execute
			raise CreateError.new("Usage: RemoteDataCli create app_name") until @command.parameters.size == 1
			project_file = "#{@command.parameters[0]}.json"

			# Initialize a file with content from template
			begin
				template_content = Template.load('templates/project_conf.json')
				project_content = template_content.gsub('$project_name', @command.parameters[0])

				Core::FileIO.init_file(project_file, project_content)
			rescue Exception => error
				puts "#{@command.action} #{project_file} with #{error}"
			end

			"#{project_file} created."
		end
	end

	class CreateError < StandardError

	end

end

# command = RemoteDataCli::Command.new("create", "app")
# creator = RemoteDataCli::Creator.new(command)
# puts creator.execute
