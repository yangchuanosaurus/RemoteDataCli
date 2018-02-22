module RemoteDataCli
	module Core
		class FileIO
			def self.init_file(project_file, content)
				mode = "w"
				File.open(project_file, mode) do |file|
					file.puts content
				end
			end
		end
	end
end