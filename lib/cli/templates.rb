require 'pathname'

module RemoteDataCli
	module Template
		def self.load(template_file)
			# Using hard code way to solve the template path
			root_path = Pathname.new(__dir__).join("../..")
			template_path = "#{root_path}/templates/#{template_file}"
			File.read(template_path)
		end
	end
end