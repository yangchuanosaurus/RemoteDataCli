require 'json'

require_relative '../cli/file_io'
require_relative '../api/api'
require_relative '../manipulate/manipulate'

module RemoteDataCli
	module Run
		class Action
			def initialize(host_alias, path, http_method)
				@host_alias = host_alias
				@path = path
				@action = path.split('/')[-1]
				@http_method = http_method

				@action_file = "#{path}_#{http_method}.json"
			end

			def run
				if !Core::FileIO.file_exists?(@action_file)
					puts "#{@action_file} doesn't exists."
				else
					project = RemoteDataCli::Core::FileIO.load_project
					url = project["hosts"][@host_alias]

					if url.nil?
						return "Cannot found the url of #{@host_alias} from project.json."
					end

					content = RemoteDataCli::Core::FileIO.load_content(@action_file)
					data_hash = JSON.parse(content)

					http_method = data_hash['http_method']

					path = data_hash['path']
					headers = data_hash['headers']
					params = data_hash['queries']

					url = "#{url}#{path}"
					connect(url, path, headers, params)

					"run #{http_method} #{path} done."
				end
			end

			def connect(url, path, headers, params)
				api = RemoteDataCli::Api::ClientApi.new
				resp = api.get(url, path, headers, params)

				model_mapping = RemoteDataCli::Mapping::Manipulate.new(@action).generate(resp.body)
				puts "======Mapping======"
				model_mapping.map do |key, value|
					puts "===#{key}->\n\t#{value}"
				end
			end
		end
	end
end