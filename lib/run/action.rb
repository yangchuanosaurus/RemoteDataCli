require 'json'

require_relative '../cli/file_io'
require_relative '../api/api'

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
					data_hash = JSON.parse(content)

					http_method = data_hash['http_method']

					path = data_hash['path']
					headers = data_hash['headers']
					params = data_hash['queries']

					url = "https://awmobile-vip.qa.aw.dev.activenetwork.com/misc"
					api = RemoteDataCli::Api::ClientApi.new
					api.get(url, path, headers, params)
					
					"run #{http_method} #{path} done."
				end
			end
		end
	end
end