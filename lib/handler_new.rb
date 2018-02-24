require_relative 'handler'
require_relative 'cli/templates'
require_relative 'cli/file_io'

module RemoteDataCli

	class Creator < Handler

		def execute
			raise CreateError.new("Usage: RemoteDataCli create app_name") until @command.parameters.size == 1
			app_name = @command.parameters[0]
			project_file = "#{app_name}/project.json"

			puts "Create a rest project"
			# Initialize a file with content from template
			begin
				app_path = Core::FileIO.create_directory(app_name)
				puts "\t#{app_path} directory created"
				template_content = Template.load('project_conf.json')
				project_content = template_content.gsub('$project_name', @command.parameters[0])

				Core::FileIO.init_file(project_file, project_content)
				
				return "#{project_file} created."
			rescue Exception => error
				puts "#{@command.action} #{project_file} with #{error}"
				return "#{project_file} creating failed."
			end
			
		end
	end

	class CreateError < StandardError

	end

end

# command = RemoteDataCli::Command.new("create", "app")
# creator = RemoteDataCli::Creator.new(command)
# puts creator.execute
