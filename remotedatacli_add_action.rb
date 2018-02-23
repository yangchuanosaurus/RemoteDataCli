require_relative 'remotedatacli_handler'
require_relative 'core/cli/templates'
require_relative 'core/cli/file_io'

module RemoteDataCli

	class AddAction < Handler

		def initialize(command)
			@command = command
		end

		def execute
			puts "Configure rest actions"

			raise AddActionError.new("Usage: RemoteDataCli add_action http_method path") until @command.parameters.size == 2
			# check if the first parameter is a http method
			http_method = @command.parameters[0]
			path = @command.parameters[1]

			# create actions directory
			full_path = "actions#{path}"
			directory_created = Core::FileIO.create_directories(full_path)
			
			puts "\t#{directory_created} directory created."

			# create paths of the action

			# create action files
			action_file_path = "actions#{path}_#{http_method}.json"
			action_file_request_path = "actions#{path}_#{http_method}_request.json"
			action_file_response_path = "actions#{path}_#{http_method}_response.json"
			
			create_action_request(action_file_request_path)
			create_action_response(action_file_response_path)
			create_action(path, http_method, action_file_path, action_file_request_path, action_file_response_path)
			
		end

		private
			def create_action(path, http_method, action_file_path, action_file_request_path, action_file_response_path)
				begin
					template_content = Template.load('templates/action_conf.json')
					action_content = template_content.gsub('$path', path)
					action_content = action_content.gsub('$http_method', http_method)
					action_content = action_content.gsub('$response_conf', action_file_response_path)
					action_content = action_content.gsub('$request_conf', action_file_request_path)

					Core::FileIO.init_file(action_file_path, action_content)

					puts "\t#{action_file_path} created."
				rescue Exception => err
					puts "#{err}"
				end
			end

			def create_action_request(action_file_request_path)
				template_content = Template.load('templates/action_request_conf.json')
				Core::FileIO.init_file(action_file_request_path, template_content)
				puts "\t#{action_file_request_path} created."
			end

			def create_action_response(action_file_response_path)
				template_content = Template.load('templates/action_response_conf.json')
				Core::FileIO.init_file(action_file_response_path, template_content)
				puts "\t#{action_file_response_path} created."
			end

	end

	class AddActionError < StandardError

	end

end
