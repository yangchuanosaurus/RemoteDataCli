require 'json'

module RemoteDataCli
	module Core
		class FileIO
			def self.init_file(project_file, content)
				mode = "w"
				File.open(project_file, mode) do |file|
					file.puts content
				end
			end

			def self.create_directories(path)
				dirname = File.dirname(path)
				tokens = dirname.split(/[\/\\]/)
				1.upto(tokens.size) do |n|
				  dir = tokens[0...n]
				  dir = dir.join("/")
				  Dir.mkdir(dir) unless Dir.exist?(dir)
				end
				tokens[0...tokens.size].join('/')
			end

			def self.create_directory(name)
				Dir.mkdir(name) unless Dir.exist?(name)
				name
			end

			def self.file_exists?(file)
				File.exist?(file)
			end

			def self.load_content(file)
				File.read(file)
			end

			def self.load_project
				content = File.read("project.json")
				JSON.parse(content)
			end
		end
	end
end