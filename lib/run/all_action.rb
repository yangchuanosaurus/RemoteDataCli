require 'json'

require_relative '../cli/file_io'
require_relative '../api/api'

module RemoteDataCli
	module Run
		class AllAction
			def initialize(host_alias, path)
				@host_alias = host_alias
				@path = path
			end

			def run
				if !Core::FileIO.file_exists?(@path)
					puts "#{@path} doesn't exists."
				else

					project = RemoteDataCli::Core::FileIO.load_project
					url = project["hosts"][@host_alias]

					if url.nil?
						return "Cannot found the url of #{@host_alias} from project.json."
					end

					content = RemoteDataCli::Core::FileIO.load_content(@path)
					data_hash = JSON.parse(content)

					http_method = data_hash['http_method']

					path = data_hash['path']
					headers = data_hash['headers']
					params = data_hash['queries']

					resp_code = connect(url, path, headers, params)

					puts "run #{http_method} #{path} with response code #{resp_code}."

				end
			end

			def connect(url, path, headers, params)
				api = RemoteDataCli::Api::ClientApi.new
				resp = api.get(url, path, headers, params)
				
				resp.code
			end

		end
	end
end
