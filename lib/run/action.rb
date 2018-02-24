require_relative '../cli/file_io'

module RemoteDataCli
	module Run
		class Action
			def initialize(path, action, http_method)
				@path = path
				@action = action
				@http_method = http_method

				@action_file = "#{path}/#{action}_#{http_method}.json"
			end

			def run
				if !Core::FileIO.file_exists?(@action_file)
					puts "#{@action_file} doesn't exists."
				else
					content = RemoteDataCli::Core::FileIO.load_content(@action_file)
				end
			end
		end
	end
end