module RemoteDataCli
	module Template
		def self.load(template_path)
			File.read(template_path)
		end
	end
end